package fr.mazerte.openflowBuilder.itemRenderer
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	
	import mx.binding.utils.BindingUtils;
	import fr.mazerte.openflowBuilder.datas.OpenFlowGlobals;

	public class ColorItemRenderer extends Sprite implements IItemRenderer
	{
		private var _index:int;
		private var _data:*;
		
		public function ColorItemRenderer()
		{
			_draw();
			
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
		
		private function _draw():void
		{			
			removeEventListener(MouseEvent.CLICK, _clickHandler);
			
			graphics.clear();
			graphics.beginFill(_data, OpenFlowGlobals.getInstance().itemAlpha);
			graphics.drawRect(0, 0, OpenFlowGlobals.getInstance().itemWidth, OpenFlowGlobals.getInstance().itemHeight);
			graphics.endFill();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(OpenFlowGlobals.getInstance().itemWidth, OpenFlowGlobals.getInstance().itemHeight, Math.PI / 4);
			
			graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, .5], [0, 255], m);
			graphics.drawRect(0, 0, OpenFlowGlobals.getInstance().itemWidth, OpenFlowGlobals.getInstance().itemHeight);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, _clickHandler);
		}
		
		public function setData(data:*):void
		{
			_data = Math.random() * 0xFFFFFF;
			_draw();
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
			//trace('rollOver: ' + _index);
		}
		
		public function rollOut():void
		{
			//trace('rollOut: ' + _index);
		}
		
		private function _clickHandler(event:MouseEvent):void
		{
			trace('click: ' + _index);
		}
		
		public function dispose():void
		{			
			removeEventListener(MouseEvent.CLICK, _clickHandler);
		}
	}
}