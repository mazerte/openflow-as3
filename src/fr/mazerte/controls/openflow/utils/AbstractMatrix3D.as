/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.utils
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;

	public class AbstractMatrix3D
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		public var rotationX:Number = 0;
		public var rotationY:Number = 0;
		public var rotationZ:Number = 0;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var scaleZ:Number = 1;
	}
}