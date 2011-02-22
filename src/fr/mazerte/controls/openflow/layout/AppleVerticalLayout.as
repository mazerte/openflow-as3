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
	
	public class AppleVerticalLayout extends EventDispatcher implements ILayout
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		public function AppleVerticalLayout()
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
		
		protected var _angleX:int = -80;
		protected var _angleY:int = 0;
		protected var _angleZ:int = 0;
		protected var _offsetX:int = 0;
		protected var _offsetY:int = 100;
		protected var _offsetZ:int = 150;
		protected var _gapX:int = 0;
		protected var _gapY:int = 120;
		protected var _gapZ:int = 1;
		
		public function getPostion(index:int, seek:Number):AbstractMatrix3D
		{
			var matrix:AbstractMatrix3D = new AbstractMatrix3D();
			switch(true)
			{
				case index <= seek - 1:
					matrix.rotationX = -_angleX;
					matrix.rotationY = -_angleY;
					matrix.rotationZ = -_angleZ;
					matrix.x = -(seek - index) * _gapX - _offsetX;
					matrix.y = -(seek - index) * _gapY - _offsetY;
					matrix.z = Math.abs(seek - index) * _gapZ + _offsetZ;
					break;
				case index >= seek + 1:
					matrix.rotationX = _angleX;
					matrix.rotationY = _angleY;
					matrix.rotationZ = _angleZ;
					matrix.x = -(seek - index) * _gapX + _offsetX;
					matrix.y = -(seek - index) * _gapY + _offsetY;
					matrix.z = Math.abs(seek - index) * _gapZ + _offsetZ;
					break;
				case index > seek - 1 && index < seek:
					matrix.rotationX = -_angleX * (seek - index);
					matrix.rotationY = -_angleY * (seek - index);
					matrix.rotationZ = -_angleZ * (seek - index);
					matrix.x = -(seek - index) * _gapX - _offsetX * (seek - index);
					matrix.y = -(seek - index) * _gapY - _offsetY * (seek - index);
					matrix.z = Math.abs(seek - index) * _gapZ + _offsetZ * (seek - index);
					break;
				case index < seek + 1 && index > seek:
					matrix.rotationX = _angleX * (index - seek);
					matrix.rotationY = _angleY * (index - seek);
					matrix.rotationZ = _angleZ * (index - seek);
					matrix.x = -(seek - index) * _gapX - _offsetX * (seek - index);
					matrix.y = -(seek - index) * _gapY - _offsetY * (seek - index);
					matrix.z = Math.abs(seek - index) * _gapZ - _offsetZ * (seek - index);
					break;
				case index == seek:
					matrix.z = 1;
					break;
			}
			
			return matrix;
		}
		
		public function getRollOverPostion(index:int, seek:Number, rollIndex:int):AbstractMatrix3D
		{
			return this.getPostion(index, seek);
		}
		
		public function get angle():Number
		{
			return _angleX;
		}
		
		public function set angle(n:Number):void
		{
			_angleX = n;
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
		
		public function get gap():Number
		{
			return _gapY;
		}
		
		public function set gap(n:Number):void
		{
			_gapY = n;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			
		}
	}
}