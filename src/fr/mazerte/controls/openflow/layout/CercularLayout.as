package fr.mazerte.controls.openflow.layout
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	public class CercularLayout extends EventDispatcher implements ILayout
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		public function CercularLayout()
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
		
		protected var _angle:Number;
		protected var _angleOffset:Number;
		
		protected var _distance:Number;
		protected var _distanceOffset:Number;
		
		protected var _gapX:Number;
		protected var _gapY:Number;
		protected var _gapZ:Number;
		
		protected var _offsetX:Number;
		protected var _offsetY:Number;
		protected var _offsetZ:Number;
		
		protected var _rotationX:Number;
		protected var _rotationY:Number;
		protected var _rotationZ:Number;
		
		protected var _globalRotationX:Number;
		protected var _globalRotationY:Number;
		protected var _globalRotationZ:Number;
		
		protected var _offsetRotationX:Number;
		protected var _offsetRotationY:Number;
		protected var _offsetRotationZ:Number;
		
		public function getPostion(index:int, seek:Number):AbstractMatrix3D
		{
			var m:AbstractMatrix3D = new AbstractMatrix3D();
			
			var px:Number, py:Number, pz:Number;
			
			m.rotationX = _rotationX * (index - seek) + _offsetRotationX;
			m.rotationY = _rotationY * (index - seek) + _offsetRotationY;
			m.rotationZ = _rotationZ * (index - seek) + _offsetRotationZ;
			
			px = Math.sin((_angle * (index - seek) + _angleOffset)) * (_distance * (index - seek) + 1) * _distanceOffset + (_gapX * (index - seek));
			py = _gapY * (index - seek);
			pz = Math.cos((_angle * (index - seek) + _angleOffset)) * (_distance * (index - seek) + 1) * _distanceOffset + (_gapZ * (index - seek));
			
			m.x = Math.cos(Math.atan2(pz, px) + _globalRotationY * (Math.PI/180)) * Math.sqrt(Math.pow(px, 2) + Math.pow(pz, 2));
			m.z = Math.sin(Math.atan2(pz, px) + _globalRotationY * (Math.PI/180)) * Math.sqrt(Math.pow(px, 2) + Math.pow(pz, 2));
			px = m.x;
			pz = m.z;
			
			m.x = Math.cos(Math.atan2(py, px) + _globalRotationZ * (Math.PI/180)) * Math.sqrt(Math.pow(px, 2) + Math.pow(py, 2));
			m.y = Math.sin(Math.atan2(py, px) + _globalRotationZ * (Math.PI/180)) * Math.sqrt(Math.pow(px, 2) + Math.pow(py, 2));
			px = m.x;
			py = m.y;
			
			m.z = Math.cos(Math.atan2(py, pz) + _globalRotationX * (Math.PI/180)) * Math.sqrt(Math.pow(pz, 2) + Math.pow(py, 2));
			m.y = Math.sin(Math.atan2(py, pz) + _globalRotationX * (Math.PI/180)) * Math.sqrt(Math.pow(pz, 2) + Math.pow(py, 2));
			
			m.x += _offsetX;
			m.y += _offsetY;
			m.z += _offsetZ; 
			
			return m;
		}
		
		public function getRollOverPostion(index:int, seek:Number, rollIndex:int):AbstractMatrix3D
		{
			return this.getPostion(index, seek);
		}
		
		public function dispose():void
		{
		}
		
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set angle(n:Number):void
		{
			_angle = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get angleOffset():Number
		{
			return _angleOffset;
		}
		
		public function set angleOffset(n:Number):void
		{
			_angleOffset = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get distance():Number
		{
			return _distance;
		}
		
		public function set distance(n:Number):void
		{
			_distance = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get distanceOffset():Number
		{
			return _distanceOffset;
		}
		
		public function set distanceOffset(n:Number):void
		{
			_distanceOffset = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get gapX():Number
		{
			return _gapX;
		}
		
		public function set gapX(n:Number):void
		{
			_gapX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get gapY():Number
		{
			return _gapY;
		}
		
		public function set gapY(n:Number):void
		{
			_gapY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get gapZ():Number
		{
			return _gapZ;
		}
		
		public function set gapZ(n:Number):void
		{
			_gapZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetX(n:Number):void
		{
			_offsetX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set offsetY(n:Number):void
		{
			_offsetY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get offsetZ():Number
		{
			return _offsetZ;
		}
		
		public function set offsetZ(n:Number):void
		{
			_offsetZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get rotationX():Number
		{
			return _rotationX;
		}
		
		public function set rotationX(n:Number):void
		{
			_rotationX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		
		public function set rotationY(n:Number):void
		{
			_rotationY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		
		public function set rotationZ(n:Number):void
		{
			_rotationZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get globalRotationX():Number
		{
			return _globalRotationX;
		}
		
		public function set globalRotationX(n:Number):void
		{
			_globalRotationX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get globalRotationY():Number
		{
			return _globalRotationY;
		}
		
		public function set globalRotationY(n:Number):void
		{
			_globalRotationY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get globalRotationZ():Number
		{
			return _globalRotationZ;
		}
		
		public function set globalRotationZ(n:Number):void
		{
			_globalRotationZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		public function get offsetRotationX():Number
		{
			return _offsetRotationX;
		}
		
		public function set offsetRotationX(n:Number):void
		{
			_offsetRotationX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get offsetRotationY():Number
		{
			return _offsetRotationY;
		}
		
		public function set offsetRotationY(n:Number):void
		{
			_offsetRotationY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get offsetRotationZ():Number
		{
			return _offsetRotationZ;
		}
		
		public function set offsetRotationZ(n:Number):void
		{
			_offsetRotationZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}