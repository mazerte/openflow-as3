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
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	[Event(name="change", type="flash.events.Event")]

	public class DefaultLayout extends EventDispatcher implements ILayout
	{
		protected var _length:int;
		protected var _width:Number;
		protected var _height:Number;
		
		public function DefaultLayout()
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
			var matrix:AbstractMatrix3D = this.getPostion(index, seek);
			
			if(index == rollIndex)
			{
				if(index > seek)
					matrix.x += 50;
				else if(index < seek)
					matrix.x -= 50;
			}
			
			return matrix;
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
		
		public function dispose():void
		{
			
		}
	}
}