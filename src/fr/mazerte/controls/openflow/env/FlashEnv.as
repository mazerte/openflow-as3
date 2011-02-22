/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.env
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.Flash3DAdapter;
	
	import mx.utils.ArrayUtil;
	
	public class FlashEnv extends Sprite implements IEnv
	{
		protected var _layout:ILayout;
		protected var _interpolators:Array;
		
		protected var _seek:Number = 0;
		
		protected var _items:Array;
		protected var _itemsDict:Dictionary;
		public var _container:Sprite;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public var clickToMove:Boolean = true;
		public var useOverAnimation:Boolean = true;
		
		public function FlashEnv(pClickToMove:Boolean = true, pUseOverAnimation:Boolean = true)
		{
			clickToMove = pClickToMove;
			useOverAnimation = pUseOverAnimation;
			
			Flash3DAdapter.register();
		}
		
		public function init(layout:ILayout, interpolators:Array):void
		{
			_layout = layout;
			_interpolators = interpolators;
			
			_items = [];
			_itemsDict = new Dictionary();
			
			_container = new Sprite();			
			addChild(_container);
			
			addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
		}
		
		public function update():void
		{
			var item:IItemRenderer;
			for each(var s:Sprite in _items)
			{
				item = _itemsDict[s] as IItemRenderer;
				Sprite(item).x = - (Sprite(item).width / 2);
				Sprite(item).y = - (Sprite(item).height / 2); 
			}
		}
		
		public function addItem(item:IItemRenderer, seek:Number, index:int, withAnim:Boolean=true):void
		{
			var itemContainer:Sprite = new Sprite();
			Sprite(item).x = - (Sprite(item).width / 2);
			Sprite(item).y = - (Sprite(item).height / 2); 
			itemContainer.addChild(item as Sprite);
			
			var position:AbstractMatrix3D = _layout.getPostion(index, seek);
			for each(var interpolator:IInterpolator in _interpolators)
			{
				if(withAnim)
					interpolator.addInterpolationItem(itemContainer, position, index, seek);
				else
					interpolator.interpolationItem(itemContainer, position, index, seek);
			}
			
			itemContainer.addEventListener(MouseEvent.CLICK, _itemClickHandler);
			itemContainer.addEventListener(MouseEvent.MOUSE_OVER, _itemMouseOverHandler);
			itemContainer.addEventListener(MouseEvent.MOUSE_OUT, _itemMouseOutHandler);
			itemContainer.addEventListener(MouseEvent.MOUSE_DOWN, _itemMouseDownHandler);
			
			_items.splice(index, 0, itemContainer);
			_itemsDict[itemContainer] = item;
			_container.addChild(itemContainer);
		}
		
		public function removeItem(item:IItemRenderer, withAnim:Boolean=true):void
		{
			for(var i:uint = 0; i < _items.length; i++)
			{
				if(_itemsDict[_items[i]] == item)
				{			
					Sprite(_items[i]).removeEventListener(MouseEvent.CLICK, _itemClickHandler);
					Sprite(_items[i]).removeEventListener(MouseEvent.MOUSE_OVER, _itemMouseOverHandler);
					Sprite(_items[i]).removeEventListener(MouseEvent.MOUSE_OUT, _itemMouseOutHandler);
					Sprite(_items[i]).removeEventListener(MouseEvent.MOUSE_DOWN, _itemMouseDownHandler);
					
					if(withAnim)
					{
						var duration:Number = 0;
						var tmpDuration:Number;
						for each(var interpolator:IInterpolator in _interpolators)
						{
							tmpDuration = interpolator.removeInterpolationItem(_items[i], i, 0);
							duration = (tmpDuration > duration) ? tmpDuration : duration;
						}
						
						setTimeout(
							function(item:Sprite):void
							{
								_container.removeChild(item);
							}, duration * 1000, _items[i]
						);
					}
					else
					{
						_container.removeChild(_items[i] as Sprite);
					}
					
					delete _itemsDict[_items[i]];
					_items.splice(i, 1);
				}
			}
		}
		
		private var _isSeeked:Boolean = true;
		
		public function setSeek(seek:Number, withAnim:Boolean=true):void
		{
			_seek = seek;
			
			if(!_items || _items.length < 1)
				return;
			
			_isSeeked = true;
			var item:Sprite;
			for(var i:uint = 0; i < _items.length; i++)
			{
				item = _items[i] as Sprite;
				item.mouseChildren = false;
				
				var position:AbstractMatrix3D = _layout.getPostion(i, seek);
				for each(var interpolator:IInterpolator in _interpolators)
				{
					if(withAnim)
						interpolator.moveInterpolationItem(item, position, i, seek);
					else
						interpolator.interpolationItem(item, position, i, seek);
				}
			}
			
			if(seek == Math.round(seek))
			{
				item = _items[seek] as Sprite;
				if(item)
					item.mouseChildren = true;
			}
		}
		
		private function _enterFrameHandler(event:Event):void
		{
			var sortItems:Array = [];
			var item:Sprite;
			for(var i:uint = 0; i < _container.numChildren; i++)
			{
				item = _container.getChildAt(i) as Sprite;
				if(!item.transform.matrix3D)
					item.transform.matrix3D = new Matrix3D();
				sortItems.push({z:item.transform.getRelativeMatrix3D(_container).position.z, item:item});
			}
				
			sortItems.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			for(var j:uint = 0; j < sortItems.length; j++)
				_container.setChildIndex(sortItems[j].item, j);
		}
		
		public function resize(width:Number, height:Number):void
		{
			graphics.clear();
			graphics.beginFill(0xFF0000, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			_container.x = width >> 1;
			_container.y = height >> 1;
			
			_width = width;
			_height = height;
		}
		
		private function _itemClickHandler(event:MouseEvent):void
		{
			if(!_items || !clickToMove)
				return;
				
			for(var i:uint = 0; i < _items.length; i++)
			{
				if(event.currentTarget == _items[i])
					dispatchEvent(new EnvEvent(EnvEvent.SEEK, i));					
			}
		}
		
		private function _itemMouseOverHandler(event:MouseEvent):void
		{
			if(!_itemsDict[event.target])
				return;
			
			IItemRenderer(_itemsDict[event.target]).rollOver();
			if(useOverAnimation)
			{
				var index:int = ArrayUtil.getItemIndex(event.target, _items);
				for(var i:uint = 0; i < _items.length; i++)
				{
					for each(var interpolator:IInterpolator in _interpolators)
						interpolator.overInterpolationItem(_items[i], _layout.getRollOverPostion(i, _seek, index), i, _seek);
				}
			}
		}
		
		private function _itemMouseOutHandler(event:MouseEvent):void
		{
			if(!_itemsDict[event.target])
				return;
			
			IItemRenderer(_itemsDict[event.target]).rollOut();
			if(useOverAnimation)
			{
				for(var i:uint = 0; i < _items.length; i++)
				{
					for each(var interpolator:IInterpolator in _interpolators)
						interpolator.moveInterpolationItem(_items[i], _layout.getPostion(i, _seek), i, _seek);
				}
			}
		}
		
		private function _itemMouseDownHandler(event:MouseEvent):void
		{
			_isSeeked = false;
		}
		
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout(l:ILayout):void
		{
			_layout = l;
		}
		
		public function get interpolators():Array
		{
			return _interpolators;
		}
		
		public function set interpolators(a:Array):void
		{
			_interpolators = a;
		}
		
		public function dispose():void
		{
			removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			
			_layout = null;
			_interpolators = null;
			
			for each(var item:Sprite in _items)
				IItemRenderer(_itemsDict[item]).dispose();
			_items = null;
			_itemsDict = null;
			
			while(_container.numChildren > 0)
				_container.removeChildAt(0)
		}
	}
}