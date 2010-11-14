/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.utils.eaze.transform3D
{
	import aze.motion.EazeTween;
	import aze.motion.specials.EazeSpecial;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class PapervisionAdapter extends EazeSpecial
	{
		static public function register():void
		{
			EazeTween.specialProperties.transform3D = PapervisionAdapter;
		}
		
		private var _orig:Matrix3D;
		private var _start:Matrix3D;
		private var _delta:Matrix3D;
		private var vvalue:Matrix3D;
		
		public function PapervisionAdapter(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target, property, value, next);
			if(value is AbstractMatrix3D)
				vvalue = _convertMatrix(value as AbstractMatrix3D);
			else
				vvalue = value;
		}
		
		override public function init(reverse:Boolean):void 
		{
			_orig = target.transform as Matrix3D;
			var st:Matrix3D = Matrix3D.clone(target.transform as Matrix3D);
			
			var end:Matrix3D;
			if (reverse) 
			{ 
				_start = vvalue; 
				end = st; 
			}
			else 
			{ 
				end = vvalue; 
				_start = st; 
			}
			
			_delta = new Matrix3D();
			_delta.n11 = end.n11 -_start.n11;
			_delta.n12 = end.n12 -_start.n12;
			_delta.n13 = end.n13 -_start.n13;
			_delta.n14 = end.n14 -_start.n14;
			
			_delta.n21 = end.n21 -_start.n21;
			_delta.n22 = end.n22 -_start.n22;
			_delta.n23 = end.n23 -_start.n23;
			_delta.n24 = end.n24 -_start.n24;
			
			_delta.n31 = end.n31 -_start.n31;
			_delta.n32 = end.n32 -_start.n32;
			_delta.n33 = end.n33 -_start.n33;
			_delta.n34 = end.n34 -_start.n34;
			
			_delta.n41 = end.n41 -_start.n41;
			_delta.n42 = end.n42 -_start.n42;
			_delta.n43 = end.n43 -_start.n43;
			_delta.n44 = end.n44 -_start.n44;
		}
		
		override public function update(ke:Number, isComplete:Boolean):void 
		{
			target.transform = _orig;
			
			target.transform.n11 = _start.n11 + (_delta.n11 * ke);
			target.transform.n12 = _start.n12 + (_delta.n12 * ke);
			target.transform.n13 = _start.n13 + (_delta.n13 * ke);
			target.transform.n14 = _start.n14 + (_delta.n14 * ke);
			
			target.transform.n21 = _start.n21 + (_delta.n21 * ke);
			target.transform.n22 = _start.n22 + (_delta.n22 * ke);
			target.transform.n23 = _start.n23 + (_delta.n23 * ke);
			target.transform.n24 = _start.n24 + (_delta.n24 * ke);
			
			target.transform.n31 = _start.n31 + (_delta.n31 * ke);
			target.transform.n32 = _start.n32 + (_delta.n32 * ke);
			target.transform.n33 = _start.n33 + (_delta.n33 * ke);
			target.transform.n34 = _start.n34 + (_delta.n34 * ke);
			
			target.transform.n41 = _start.n41 + (_delta.n41 * ke);
			target.transform.n42 = _start.n42 + (_delta.n42 * ke);
			target.transform.n43 = _start.n43 + (_delta.n43 * ke);
			target.transform.n44 = _start.n44 + (_delta.n44 * ke);
		}
		
		private function _convertMatrix(m:AbstractMatrix3D):Matrix3D
		{
			var mock:DisplayObject3D = new DisplayObject3D();
			mock.x = m.x;					mock.y = m.y; 					mock.z = m.z;
			mock.rotationX = m.rotationX; 	mock.rotationY = m.rotationY; 	mock.rotationZ = m.rotationZ;
			mock.scaleX = m.scaleX; 		mock.scaleY = m.scaleY; 		mock.scaleZ = m.scaleZ;
			mock.updateTransform();
			return Matrix3D.clone(mock.transform);
		}
	}
}