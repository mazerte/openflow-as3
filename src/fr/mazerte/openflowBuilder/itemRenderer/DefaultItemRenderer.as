/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.openflowBuilder.itemRenderer
{
	import aze.motion.eaze;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.openflowBuilder.datas.OpenFlowGlobals;
	
	import mx.binding.utils.BindingUtils;
	
	public class DefaultItemRenderer extends Sprite implements IItemRenderer
	{
		private var _index:int;
		private var _data:*;
		
		private var _ball:Sprite;
		
		public function DefaultItemRenderer()
		{
			_ball = new Sprite();
			_ball.addEventListener(MouseEvent.MOUSE_OVER, _ballMouseOverHandler);
			_ball.addEventListener(MouseEvent.MOUSE_OUT, _ballMouseOutHandler);
			addChild(_ball);
			
			_draw();
			
			_anim();
			
			BindingUtils.bindSetter(
				function(pWidth:Number):void
				{
					_draw();
				}, OpenFlowGlobals.getInstance(), "itemWidth"
			);
			
			BindingUtils.bindSetter(
				function(pWidth:Number):void
				{
					_draw();
				}, OpenFlowGlobals.getInstance(), "itemHeight"
			);
			
			BindingUtils.bindSetter(
				function(pWidth:Number):void
				{
					_draw();
				}, OpenFlowGlobals.getInstance(), "itemAlpha"
			);
		}
		
		private function _anim():void
		{
			eaze(_ball).apply({x: (OpenFlowGlobals.getInstance().itemWidth / 2) - 100, y: (OpenFlowGlobals.getInstance().itemHeight / 2) - 100})
				.to(5,{x: (OpenFlowGlobals.getInstance().itemWidth / 2) + 100, y: (OpenFlowGlobals.getInstance().itemHeight / 2) - 100})
				.to(5,{x: (OpenFlowGlobals.getInstance().itemWidth / 2) + 100, y: (OpenFlowGlobals.getInstance().itemHeight / 2) + 100})
				.to(5,{x: (OpenFlowGlobals.getInstance().itemWidth / 2) - 100, y: (OpenFlowGlobals.getInstance().itemHeight / 2) + 100})
				.to(5,{x: (OpenFlowGlobals.getInstance().itemWidth / 2) - 100, y: (OpenFlowGlobals.getInstance().itemHeight / 2) - 100})
				.onComplete(_anim);
		}
		
		private function _ballMouseOverHandler(event:MouseEvent):void
		{
			_ball.graphics.clear();
			_ball.graphics.beginFill(0x000000, OpenFlowGlobals.getInstance().itemAlpha);
			_ball.graphics.drawEllipse(0, 0, 40, 40);
			_ball.graphics.endFill();
		}
		
		private function _ballMouseOutHandler(event:MouseEvent):void
		{
			_ball.graphics.clear();
			_ball.graphics.beginFill(0x0000FF, OpenFlowGlobals.getInstance().itemAlpha);
			_ball.graphics.drawEllipse(0, 0, 40, 40);
			_ball.graphics.endFill();
		}
		
		private function _draw():void
		{			
			removeEventListener(MouseEvent.CLICK, _clickHandler);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, OpenFlowGlobals.getInstance().itemAlpha);
			graphics.lineStyle(1, 0xFF0000);
			graphics.drawRect(0, 0, OpenFlowGlobals.getInstance().itemWidth, OpenFlowGlobals.getInstance().itemHeight);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x00FF00);
			
			graphics.moveTo(0, 0);
			graphics.lineTo(OpenFlowGlobals.getInstance().itemWidth, OpenFlowGlobals.getInstance().itemHeight);
			
			graphics.moveTo(0, OpenFlowGlobals.getInstance().itemHeight);
			graphics.lineTo(OpenFlowGlobals.getInstance().itemWidth, 0);
			
			_ball.graphics.clear();
			_ball.graphics.beginFill(0x0000FF, OpenFlowGlobals.getInstance().itemAlpha);
			_ball.graphics.drawEllipse(0, 0, 40, 40);
			_ball.graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, _clickHandler);
		}
		
		public function setData(data:*):void
		{
			_data = data;
			_index = data;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(i:int):void
		{
			_index = i;
		}
		
		public function focusIn():void 
		{
			//trace('focusIn: ' + _index);
		}
		
		public function focusOut():void 
		{
			//trace('focusOut: ' + _index);
		}
		
		public function rollOver():void
		{
			trace('rollOver: ' + _index);
		}
		
		public function rollOut():void
		{
			trace('rollOut: ' + _index);
		}
		
		private function _clickHandler(event:MouseEvent):void
		{
			trace('click: ' + _index);
		}
		
		public function dispose():void
		{		
			_ball.removeEventListener(MouseEvent.MOUSE_OVER, _ballMouseOverHandler);
			_ball.removeEventListener(MouseEvent.MOUSE_OUT, _ballMouseOutHandler);
			
			removeEventListener(MouseEvent.CLICK, _clickHandler);
		}
	}
}