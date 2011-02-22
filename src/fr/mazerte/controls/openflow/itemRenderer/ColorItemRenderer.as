package fr.mazerte.controls.openflow.itemRenderer
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class ColorItemRenderer extends Sprite implements IItemRenderer
	{
		private static const _WIDTH:Number = 444;
		private static const _HEIGHT:Number = 326;
		private static const _ALPHA:Number = 1;
		
		private var _index:int;
		private var _data:*;
		
		public function ColorItemRenderer()
		{
			_draw();
		}
		
		private function _draw():void
		{			
			removeEventListener(MouseEvent.CLICK, _clickHandler);
			
			graphics.clear();
			graphics.beginFill(_data, _ALPHA);
			graphics.drawRect(0, 0, _WIDTH, _HEIGHT);
			graphics.endFill();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(_WIDTH, _HEIGHT, Math.PI / 4);
			
			graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, .5], [0, 255], m);
			graphics.drawRect(0, 0, _WIDTH, _HEIGHT);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, _clickHandler);
		}
		
		public function setData(data:*):void
		{
			_data = data;
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