/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.interpolator
{
	import aze.motion.easing.Quadratic;
	import aze.motion.eaze;
	
	import flash.display.Sprite;
	
	import fr.mazerte.controls.openflow.error.EnvError;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;

	public class DefaultInterpolator implements IInterpolator
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _duration:Number = .5;
		
		public function DefaultInterpolator()
		{
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
		}
		
		public function setLength(len:int):void
		{
			_length = len;
		}
		
		public function addInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			var m:AbstractMatrix3D = new AbstractMatrix3D();
			m.z = 1000;
			eaze(item)
				.easing(Quadratic.easeOut)
				.apply({ transform3D:m })
				.to(_duration, { transform3D:transform }, false);
			return _duration;
		}
		
		public function moveInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { transform3D:transform }, false);
			return _duration;
		}
		
		public function overInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			eaze(item)
			.easing(Quadratic.easeOut)
				.to(_duration, { transform3D:transform }, false);
			return _duration;
		}
		
		public function interpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			eaze(item).apply({ transform3D:transform });
			return 0;
		}
		
		public function removeInterpolationItem(item:*, index:Number, seek:Number):Number
		{
			var m:AbstractMatrix3D = new AbstractMatrix3D();	
			m.z = 1000;			
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { transform3D:m }, false);
			return _duration;
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function set duration(n:Number):void
		{
			_duration = n;
		}
		
		public function dispose():void
		{
			
		}
	}
}