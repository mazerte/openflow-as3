package fr.mazerte.controls.openflow.interpolator
{
	import aze.motion.easing.Quadratic;
	import aze.motion.eaze;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Transform;
	
	import fr.mazerte.controls.openflow.error.EnvError;
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.EnvUtils;
	
	public class FogInterpolator implements fr.mazerte.controls.openflow.interpolator.IInterpolator
	{		
		protected var _env:String;
		
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _duration:Number = .5;
		
		protected var _fogDistance:Number = 901;
		
		public function FogInterpolator()
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
			item = _resoveItemType(item);
				
			eaze(item)
				.easing(Quadratic.easeOut)
				.apply({ alpha:0 }, false)
				.to(_duration, { alpha:(transform.z < _fogDistance)?1:0 }, false);
			return _duration;
		}
		
		public function moveInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			item = _resoveItemType(item);
			
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { alpha:(transform.z < _fogDistance)?1:0 }, false);
			return _duration;
		}
		
		public function overInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			return 0;
		}
		
		public function interpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			item = _resoveItemType(item);
			
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { alpha:(transform.z < _fogDistance)?1:0 }, false);
			return _duration;
		}
		
		public function removeInterpolationItem(item:*, index:Number, seek:Number):Number
		{
			item = _resoveItemType(item);
						
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { alpha:0 }, false);
			return _duration;
		}
		
		public function dispose():void
		{
			
		}
		
		
		private function _resoveItemType(item:*):*
		{		
			if(!_env)
				_env = EnvUtils.getEnv(item);
			
			switch(_env)
			{
				case EnvUtils.FLASH_3D:
					return item;
				case EnvUtils.AWAY_3D:
					return item.material.movie;
				case EnvUtils.PAPERVISION_3D:
					return item.material.movie;
				default:
					throw new EnvError(EnvUtils.FLASH_3D + "/" + EnvUtils.AWAY_3D + "/" + EnvUtils.PAPERVISION_3D);
			}
			return null;
		}
		
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function set duration(n:Number):void
		{
			_duration = n;
		}
		
		
		public function get fogDistance():Number
		{
			return _fogDistance;
		}
		
		public function set fogDistance(n:Number):void
		{
			_fogDistance = n;
		}
	}
}