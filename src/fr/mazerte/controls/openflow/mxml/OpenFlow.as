/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.mxml
{
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import fr.mazerte.controls.openflow.core.OpenFlowBase;
	import fr.mazerte.controls.openflow.env.IEnv;
	import fr.mazerte.controls.openflow.events.SeekEvent;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.seek.ISeeker;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	[Event(name="change", type="flash.events.Event")]
	[Event(name="seek", type="fr.mazerte.controls.openflow.events.SeekEvent")]
	[Event(name="roundedSeek", type="fr.mazerte.controls.openflow.events.SeekEvent")]
	
	[Style(name="bgColor", type="uint", format="Color", inherit="yes")]
	[Style(name="bgAlpha", type="Number", inherit="yes")]
	
	public class OpenFlow extends UIComponent
	{
		private var _base:OpenFlowBase;
		
		private var _data:ArrayCollection;
		private var _itemRenderer:Class;
		private var _env:IEnv;
		private var _layout:ILayout;
		private var _interpolators:Array;
		private var _seeker:ISeeker;
		
		public function OpenFlow()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_base = new OpenFlowBase(_data.toArray(), _itemRenderer, _env, _layout, _interpolators, _seeker);
			_base.addEventListener(SeekEvent.SEEK, _seekHandler);
			_base.addEventListener(SeekEvent.ROUNDED_SEEK, _seekHandler);
			addChild(_base);
		}
		
		private function _seekHandler(event:SeekEvent):void
		{
			var ev:SeekEvent = new SeekEvent(event.type, event.seek, event.withAnim, event.bubbles, event.cancelable);
			dispatchEvent(ev);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			transform.perspectiveProjection = new PerspectiveProjection();
			transform.perspectiveProjection.fieldOfView = 45;
			transform.perspectiveProjection.focalLength = 1000;
			transform.perspectiveProjection.projectionCenter = new Point(unscaledWidth >> 1, unscaledHeight >> 1);
			
			_base.width = unscaledWidth;
			_base.height = unscaledHeight;
			
			var bgColor:uint = getStyle("bgColor") || 0x000000;
			var bgAlpha:Number = getStyle("bgAlpha") || 0;
			graphics.clear();
			graphics.beginFill(bgColor, bgAlpha);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
		public function update():void
		{
			_base.update();
		}
		
		[bindable('change')]
		public function get data():ArrayCollection
		{
			return _data;
		}
		
		public function set data(a:ArrayCollection):void
		{
			_data = a;
			if(_base)
				_base.data = _data.toArray();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		[bindable('change')]
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}
		
		public function set itemRenderer(c:Class):void
		{
			_itemRenderer = c;
			if(_base)
				_base.itemRenderer = c;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		[bindable('change')]
		public function get env():IEnv
		{
			return _env;
		}
		
		public function set env(e:IEnv):void
		{
			_env = e;
			if(_base)
				_base.env = e;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		[bindable('change')]
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout(l:ILayout):void
		{
			_layout = l;
			if(_base)
				_base.layout = l;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		[bindable('change')]
		public function get interpolators():Array
		{
			return _interpolators;
		}
		
		public function set interpolators(a:Array):void
		{
			_interpolators = a;
			if(_base)
				_base.interpolators = a;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		[bindable('change')]
		public function get seeker():ISeeker
		{
			return _seeker;
		}
		
		public function set seeker(s:ISeeker):void
		{
			_seeker = s;
			if(_base)
				_base.seeker = s;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function getSeek():Number
		{
			if(_base)
				return _base.getSeek();
			return 0;
		}
		
		public function setSeek(seek:Number, withAnim:Boolean = true, forceAnim:Boolean = false):void
		{
			if(_base)
				_base.setSeek(seek, withAnim, forceAnim);
		}
		
		public function next():void
		{
			if(_base)
				_base.next();
		}
		
		public function prev():void
		{
			if(_base)
				_base.prev();
		}
		
		public function fix():void
		{
			if(_base)
				_base.fix();
		}
		
		public function dispose():void
		{
			_base.removeEventListener(SeekEvent.SEEK, _seekHandler);
			_base.removeEventListener(SeekEvent.ROUNDED_SEEK, _seekHandler);
			_base.dispose();
			_base = null;
			
			_data = null;
			_itemRenderer = null;
			_env = null;
			_layout = null;
			_interpolators = null;
		}
	}
}