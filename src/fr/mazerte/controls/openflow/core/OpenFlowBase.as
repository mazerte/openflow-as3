/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fr.mazerte.controls.openflow.env.EnvEvent;
	import fr.mazerte.controls.openflow.env.FlashEnv;
	import fr.mazerte.controls.openflow.env.IEnv;
	import fr.mazerte.controls.openflow.events.SeekEvent;
	import fr.mazerte.controls.openflow.interpolator.DefaultInterpolator;
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.itemRenderer.DefaultItemRenderer;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.DefaultLayout;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.seek.DefaultSeeker;
	import fr.mazerte.controls.openflow.seek.ISeeker;
	import fr.mazerte.controls.openflow.utils.eaze.PropertyTransform3D;
	
	[Event(name="seek", type="fr.mazerte.controls.openflow.events.SeekEvent")]
	[Event(name="roundedSeek", type="fr.mazerte.controls.openflow.events.SeekEvent")]

	public class OpenFlowBase extends Sprite
	{
		protected var _data:Array;
		protected var _itemRenderer:Class;
		protected var _env:IEnv;
		protected var _layout:ILayout;
		protected var _interpolators:Array;
		protected var _seeker:ISeeker;
		
		protected var _items:Array;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _isInit:Boolean = false;
		
		protected var _seek:Number;
		
		protected var _itemOnFocus:IItemRenderer;
		
		public function OpenFlowBase(data:Array = null, itemRenderer:Class = null, env:IEnv = null, layout:ILayout = null, interpolators:Array = null, seeker:ISeeker = null)
		{
			_data = data || [];
			_itemRenderer = itemRenderer || DefaultItemRenderer;
			_env = env || new FlashEnv();
			_layout = layout || new DefaultLayout();
			_interpolators = interpolators || [new DefaultInterpolator()];
			_seeker = seeker;
			
			_seek = Math.floor(_data.length / 2);
			_layout.setLength(_data.length);
			for each(var interpolator:IInterpolator in _interpolators)
				interpolator.setLength(_data.length);
			
			if(stage)
				_init();
			else
				addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		protected function _init(event:Event = null):void
		{
			_isInit = true;
			
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			_layout.setSize(_width, _height);
			_layout.addEventListener(Event.CHANGE, _layoutChangeHandler);
			
			for each(var interpolator:IInterpolator in _interpolators)
				interpolator.setSize(_width, _height);
				
			_env.init(_layout, _interpolators);
			_env.resize(_width, _height);
			_env.addEventListener(EnvEvent.SEEK, _envSeekHandler);
			addChild(_env as Sprite);
			
			if(_seeker)
				_seeker.init(this);
			
			_drawUI(true);
		}
		
		private function _layoutChangeHandler(event:Event):void
		{
			setSeek(_seek);
		}
		
		protected function _drawUI(withAnim:Boolean = false):void
		{	
			if(!_itemRenderer)
				return
			
			_items = [];
			var renderer:IItemRenderer;
			for(var i:uint; i < _data.length; i++)
			{
				renderer = new _itemRenderer() as IItemRenderer;
				renderer.setData(_data[i]);
				
				_env.addItem(renderer, _seek, _items.length, withAnim);
				
				_items.push(renderer);
			}
			dispatchEvent(new SeekEvent(SeekEvent.ROUNDED_SEEK, _seek, withAnim));
		}
		
		protected function _clearUI():void
		{
			for each(var item:IItemRenderer in _items)
			{
				_env.removeItem(item, false);
			}
			_items = [];
		}	
		
		
		override public function get width():Number
		{
			return _width;
		}		
		
		override public function set width(n:Number):void
		{
			_width = n;
			_resize();
		}	
		
		override public function get height():Number
		{
			return _height;
		}		
		
		override public function set height(n:Number):void
		{
			_height = n;
			_resize();
		}
		
		public function update():void
		{
			_env.update();
		}
		
		protected function _resize():void
		{
			if(!_isInit)
				return;
			
			_layout.setSize(_width, _height);
			for each(var interpolator:IInterpolator in _interpolators)
				interpolator.setSize(_width, _height);
			
			_env.resize(_width, _height);
			
			_clearUI();
			_drawUI();
		}
		
		
		public function get data():Array
		{
			return _data;
		}
		
		public function set data(a:Array):void
		{
			var flag:Boolean = false;
			var renderer:IItemRenderer;
			var items:Array = [];
			
			_layout.setLength(a.length);
			
			for(var i:uint = 0; i < a.length; i++)
			{
				flag = false;
				for(var j:uint = 0; j < _data.length; j++)
				{
					if(a[i] === _data[j])
					{
						items.push(_items[j]);
						_items.splice(j, 1);
						_data.splice(j, 1);
						flag = true;
						break;
					}
				}
				if(!flag)
				{
					renderer = new _itemRenderer() as IItemRenderer;
					renderer.setData(a[i]);
					
					_env.addItem(renderer, _seek, items.length, true);
					
					items.push(renderer);
				}
			}
			for(var k:uint = 0; k < _items.length; k++)
			{
				_env.removeItem(_items[k], true);
			}
			
			_data = a;
			_items = items;
			
			_layout.setLength(_data.length);
			for each(var interpolator:IInterpolator in _interpolators)
				interpolator.setLength(_data.length);
			
			setSeek(_seek, true, true);
		}
		
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}
		
		public function set itemRenderer(c:Class):void
		{
			_itemRenderer = c; 
			
			_clearUI();
			_drawUI();
		}
		
		public function get env():IEnv
		{
			return _env;
		}
		
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout(l:ILayout):void
		{
			_layout.removeEventListener(Event.CHANGE, _layoutChangeHandler);
			_layout = l;
			_layout.setLength(_data.length);
			_layout.setSize(_width, _height);
			_layout.addEventListener(Event.CHANGE, _layoutChangeHandler);
			
			_env.layout = _layout;
			setSeek(_seek, true, true);
		}
		
		public function get interpolators():Array
		{
			return _interpolators;
		}
		
		public function set interpolators(a:Array):void
		{
			_interpolators = a;
			for each(var interpolator:IInterpolator in _interpolators)
			{
				interpolator.setLength(_data ? _data.length : 0);
				interpolator.setSize(_width, _height);
			}
			
			if(_env)
				_env.interpolators = _interpolators;
			setSeek(_seek, true, true);
		}
		
		public function get seeker():ISeeker
		{
			return _seeker;
		}
		
		public function set seeker(s:ISeeker):void
		{
			_seeker = s;
			_seeker.init(this);
		}
		
		public function getSeek():Number
		{
			return _seek;
		}
		
		public function setSeek(n:Number, withAnim:Boolean = true, forceAnim:Boolean = false):void
		{		
			if(!_data || !_itemRenderer || !_layout || !_env || !_interpolators || _interpolators.length == 0)
				return;
			
			var oldSeek:Number = _seek;
			if(withAnim)
			{
				
				if(n <= 0)
					_seek = 0;
				else if(n > _data.length - 1)
					_seek = _data.length - 1;
				else
					_seek = n;
			}
			else
				_seek = n;
			
			if(_seeker && withAnim && (oldSeek != _seek) && !forceAnim)
			{
				_seeker.start(oldSeek);
				_seeker.goto(_seek);
			}
			else
				_env.setSeek(_seek, withAnim);
			
			if(_seek == Math.round(_seek))
			{
				if(_itemOnFocus && _items[_seek] != _itemOnFocus)
				{
					if(_itemOnFocus) _itemOnFocus.focusOut();
					_itemOnFocus = _items[_seek] as IItemRenderer;
					if(_itemOnFocus) _itemOnFocus.focusIn();
				}
				else if(_items[_seek] != _itemOnFocus)
				{
					_itemOnFocus = _items[_seek] as IItemRenderer;
					if(_itemOnFocus) _itemOnFocus.focusIn();
				}
				
				dispatchEvent(new SeekEvent(SeekEvent.ROUNDED_SEEK, _seek, withAnim));
			}
			else
				dispatchEvent(new SeekEvent(SeekEvent.SEEK, _seek, withAnim));
		}
		
		private function _envSeekHandler(event:EnvEvent):void
		{
			setSeek(event.seek);
		}
		
		public function fix():void
		{
			setSeek(Math.round(_seek));
		}
		
		public function next():void
		{
			_seek = Math.round(_seek);
			setSeek((_seek < _data.length - 1) ? _seek + 1 : _seek);
		}
		
		public function prev():void
		{
			_seek = Math.round(_seek);
			setSeek((_seek > 0) ? _seek - 1 : _seek);
		}
		
		
		public function dispose():void
		{
			if(_env) _env.removeEventListener(EnvEvent.SEEK, _envSeekHandler);
			if(_layout) _layout.removeEventListener(Event.CHANGE, _layoutChangeHandler);
			
			for each(var interpolator:IInterpolator in _interpolators)
				interpolator.dispose();
			
			if(_layout) _layout.dispose();
			if(_env) _env.dispose();
			
			_data = null;
			_itemRenderer = null;
			_env = null;
			_layout = null;
			_interpolators = null;
			_itemOnFocus = null;
			_seeker = null;
		}
		
	}
}