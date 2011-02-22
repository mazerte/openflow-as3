/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class PowerLayout extends EventDispatcher implements ILayout
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		public function PowerLayout()
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
		
		protected var _angleX:int = 0;
		protected var _angleY:int = 65;
		protected var _angleZ:int = 0;
		protected var _offsetX:int = 75;
		protected var _offsetY:int = 0;
		protected var _offsetZ:int = 0;
		protected var _gapX:int = 300;
		protected var _gapY:int = 0;
		protected var _gapZ:int = 300;
		protected var _powerX:int = 1;
		protected var _powerY:int = 2;
		protected var _powerZ:int = 1;
		
		public function getPostion(index:int, seek:Number):AbstractMatrix3D
		{
			var matrix:AbstractMatrix3D = new AbstractMatrix3D();
			switch(true)
			{
				case index <= seek - 1:
					matrix.rotationX = -_angleX;
					matrix.rotationY = -_angleY;
					matrix.rotationZ = -_angleZ;
					matrix.x = Math.pow(-(seek - index), _powerX) * _gapX - _offsetX;
					matrix.y = Math.pow(-(seek - index), _powerY) * _gapY - _offsetY;
					matrix.z = Math.pow(-(seek - index), _powerZ) * _gapZ + _offsetZ;
					break;
				case index >= seek + 1:
					matrix.rotationX = _angleX;
					matrix.rotationY = _angleY;
					matrix.rotationZ = _angleZ;
					matrix.x = Math.pow(-(seek - index), _powerX) * _gapX + _offsetX;
					matrix.y = Math.pow(-(seek - index), _powerY) * _gapY + _offsetY;
					matrix.z = Math.pow(-(seek - index), _powerZ) * _gapZ + _offsetZ;
					break;
				case index > seek - 1 && index < seek:
					matrix.rotationX = -_angleX * (seek - index);
					matrix.rotationY = -_angleY * (seek - index);
					matrix.rotationZ = -_angleZ * (seek - index);
					matrix.x = Math.pow(-(seek - index), _powerX) * _gapX - _offsetX * Math.pow(-(seek - index), _powerX);
					matrix.y = Math.pow(-(seek - index), _powerY) * _gapY - _offsetY * Math.pow(-(seek - index), _powerY);
					matrix.z = Math.pow(-(seek - index), _powerZ) * _gapZ + _offsetZ * Math.pow(-(seek - index), _powerZ);
					break;
				case index < seek + 1 && index > seek:
					matrix.rotationX = _angleX * (index - seek);
					matrix.rotationY = _angleY * (index - seek);
					matrix.rotationZ = _angleZ * (index - seek);
					matrix.x = Math.pow(-(seek - index), _powerX) * _gapX - _offsetX * Math.pow(-(seek - index), _powerX);
					matrix.y = Math.pow(-(seek - index), _powerY) * _gapY - _offsetY * Math.pow(-(seek - index), _powerY);
					matrix.z = Math.pow(-(seek - index), _powerZ) * _gapZ - _offsetZ * Math.pow(-(seek - index), _powerZ);
					break;
				case index == seek:
					matrix.z = 1;
					break;
			}
			
			return matrix;
		}
		
		public function getRollOverPostion(index:int, seek:Number):AbstractMatrix3D
		{
			return this.getPostion(index, seek);
		}
		
		public function get angleX():Number
		{
			return _angleX;
		}
		
		public function set angleX(n:Number):void
		{
			_angleX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get angleY():Number
		{
			return _angleY;
		}
		
		public function set angleY(n:Number):void
		{
			_angleY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get angleZ():Number
		{
			return _angleZ;
		}
		
		public function set angleZ(n:Number):void
		{
			_angleZ = n;
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
		
		public function get powerX():Number
		{
			return _powerX;
		}
		
		public function set powerX(n:Number):void
		{
			_powerX = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get powerY():Number
		{
			return _powerY;
		}
		
		public function set powerY(n:Number):void
		{
			_powerY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get powerZ():Number
		{
			return _powerZ;
		}
		
		public function set powerZ(n:Number):void
		{
			_powerZ = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			
		}
	}
}