package fr.mazerte.controls.openflow.interpolator
{	
	import aze.motion.easing.Quadratic;
	import aze.motion.eaze;
	
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Transform;
	
	import fr.mazerte.controls.openflow.error.EnvError;
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.EnvUtils;

	public class BlurInterpolator implements IInterpolator
	{
		protected var _env:String;
		
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _duration:Number = .5;
		
		protected var _maxBlur:Number = 10;
		protected var _maxZ:Number = 900;
		protected var _blurAfterMax:Number = 10;
		protected var _quality:int = 1;
		
		public function BlurInterpolator()
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
			
			var blur:Number = transform.z/_maxZ * _maxBlur;
			blur = (blur<_maxBlur) ? blur : _blurAfterMax;
			
			eaze(item)
				.apply({ blurFilter:{ blurX:blur, blurY:blur, quality:_quality } }, false);
			return 0;
		}
		
		public function moveInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			item = _resoveItemType(item);	
			
			var blur:Number = transform.z/_maxZ * _maxBlur;
			blur = (blur<_maxBlur) ? blur : _blurAfterMax;
			
			eaze(item)
				.easing(Quadratic.easeOut)
				.to(_duration, { blurFilter:{ blurX:blur, blurY:blur, quality:_quality } }, false);
			return _duration;
		}
		
		public function overInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			return 0;
		}
		
		public function interpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number
		{
			item = _resoveItemType(item);	
			
			var blur:Number = transform.z/_maxZ * _maxBlur;
			blur = (blur<_maxBlur) ? blur : _blurAfterMax;
			item.filters = [new BlurFilter(blur, blur, _quality)];
			return 0;
		}
		
		public function removeInterpolationItem(item:*, index:Number, seek:Number):Number
		{
			return 0;
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
		
		
		public function get maxBlur():Number
		{
			return _maxBlur;
		}
		
		public function set maxBlur(n:Number):void
		{
			_maxBlur = n;
		}
		
		public function get maxZ():Number
		{
			return _maxZ;
		}
		
		public function set maxZ(n:Number):void
		{
			_maxZ = n;
		}
		
		public function get blurAfterMax():Number
		{
			return _blurAfterMax;
		}
		
		public function set blurAfterMax(n:Number):void
		{
			_blurAfterMax = n;
		}
		
		public function get quality():int
		{
			return _quality;
		}
		
		public function set quality(i:int):void
		{
			_quality = i;
		}
	}
}