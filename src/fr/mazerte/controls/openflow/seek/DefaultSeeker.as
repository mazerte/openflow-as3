package fr.mazerte.controls.openflow.seek
{
	import aze.motion.easing.Quadratic;
	import aze.motion.eaze;
	
	import fr.mazerte.controls.openflow.core.OpenFlowBase;

	public class DefaultSeeker implements ISeeker
	{
		protected var _openFlow:OpenFlowBase;
		public var mock:Number;
		
		protected var _start:Number;
		protected var _end:Number;
		
		protected var _easing:Function;
		protected var _duration:Number = .5;
		
		public function DefaultSeeker()
		{
			_easing = Quadratic.easeOut;
		}
		
		public function init(openFlow:OpenFlowBase):void
		{
			_openFlow = openFlow;
		}
		
		public function start(value:Number):void
		{
			mock = value;
			_start = value;
		}
		
		public function goto(value:Number):void
		{
			_end = value;
			if(Math.round(_start) != Math.round(_end))
				eaze(this).to(_duration, { mock: value }).easing(_easing).onUpdate(_update);
			else
				_openFlow.setSeek(_end, true);
		}
		
		protected function _update():void
		{
			_openFlow.setSeek(mock, false);
		}
		
		public function get easing():Function
		{
			return _easing;
		}
		
		public function set easing(f:Function):void
		{
			_easing = f;
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function set duration(n:Number):void
		{
			_duration = n;
		}
	}
}