package fr.mazerte.controls.openflow.layout
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	public class CircleInLayout extends EventDispatcher implements ILayout
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		public function CircleInLayout()
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
		
		//////////////////////////////////////
		protected var _cirleGap:Number;
		
		public function getPostion(index:int, seek:Number):AbstractMatrix3D
		{
			_angle = (Math.PI * 2) / _length;
			_distanceOffset = (_cirleGap * _length) / (Math.PI * 2);
			_offsetZ = -_distanceOffset;
			
			/////////////////////
			
			_angleOffset = 0;
			
			_distance = 0;
			
			_gapX = 0;
			_gapY = 0;
			_gapZ = 0;
			
			_offsetX = 0;
			_offsetY = 0;
			
			_rotationX = 0;
			_rotationY = 360 / _length;
			_rotationZ = 0;
			
			_globalRotationX = 0;
			_globalRotationY = 0;
			_globalRotationZ = 0;
			
			_offsetRotationX = 0;
			_offsetRotationY = 0;
			_offsetRotationZ = 0;
			
			/////////////////////////
			
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
		
		public function get gap():Number
		{
			return _cirleGap;
		}
		
		public function set gap(n:Number):void
		{
			_cirleGap = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}