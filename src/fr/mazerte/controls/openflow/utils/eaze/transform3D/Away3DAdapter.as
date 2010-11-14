/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.utils.eaze.transform3D
{
	import away3d.core.base.Object3D;
	import away3d.core.math.MatrixAway3D;
	
	import aze.motion.EazeTween;
	import aze.motion.specials.EazeSpecial;
	
	import flash.sampler.NewObjectSample;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	public class Away3DAdapter extends EazeSpecial
	{		
		static public function register():void
		{
			EazeTween.specialProperties.transform3D = Away3DAdapter;
		}
		
		private var _orig:MatrixAway3D;
		private var _start:MatrixAway3D;
		private var _delta:MatrixAway3D;
		private var vvalue:MatrixAway3D;
		
		public function Away3DAdapter(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target, property, value, next);
			if(value is AbstractMatrix3D)
				vvalue = _convertMatrix(value as AbstractMatrix3D);
			else
				vvalue = value;
		}
		
		override public function init(reverse:Boolean):void 
		{
			//_orig = target.transform as MatrixAway3D;
			var st:MatrixAway3D = new MatrixAway3D();
			st.clone(target.transform);
			
			var end:MatrixAway3D;
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
			
			_delta = new MatrixAway3D();
			_delta.sxx = end.sxx -_start.sxx;
			_delta.syx = end.syx -_start.syx;
			_delta.szx = end.szx -_start.szx;
			_delta.swx = end.swx -_start.swx;
			
			_delta.sxy = end.sxy -_start.sxy;
			_delta.syy = end.syy -_start.syy;
			_delta.szy = end.szy -_start.szy;
			_delta.swy = end.swy -_start.swy;
			
			_delta.sxz = end.sxz -_start.sxz;
			_delta.syz = end.syz -_start.syz;
			_delta.szz = end.szz -_start.szz;
			_delta.swz = end.swz -_start.swz;
			
			_delta.tx = end.tx -_start.tx;
			_delta.ty = end.ty -_start.ty;
			_delta.tz = end.tz -_start.tz;
			_delta.tw = end.tw -_start.tw;
		}
		
		override public function update(ke:Number, isComplete:Boolean):void 
		{
			var m:MatrixAway3D = new MatrixAway3D();
			
			m.sxx = _start.sxx + (_delta.sxx * ke);
			m.syx = _start.syx + (_delta.syx * ke);
			m.szx = _start.szx + (_delta.szx * ke);
			m.swx = _start.swx + (_delta.swx * ke);
			
			m.sxy = _start.sxy + (_delta.sxy * ke);
			m.syy = _start.syy + (_delta.syy * ke);
			m.szy = _start.szy + (_delta.szy * ke);
			m.swy = _start.swy + (_delta.swy * ke);
			
			m.sxz = _start.sxz + (_delta.sxz * ke);
			m.syz = _start.syz + (_delta.syz * ke);
			m.szz = _start.szz + (_delta.szz * ke);
			m.swz = _start.swz + (_delta.swz * ke);
			
			m.tx = _start.tx + (_delta.tx * ke);
			m.ty = _start.ty + (_delta.ty * ke);
			m.tz = _start.tz + (_delta.tz * ke);
			m.tw = _start.tw + (_delta.tw * ke);
			
			target.transform = m;
		}
		
		private function _convertMatrix(m:AbstractMatrix3D):MatrixAway3D
		{
			var mock:Object3D = new Object3D();
			var m2:MatrixAway3D = new MatrixAway3D();
			mock.x = m.x;						mock.y = m.y; 							mock.z = m.z;
			mock.rotationX = m.rotationX - 90; 	mock.rotationY = m.rotationY + 180; 	mock.rotationZ = m.rotationZ;
			mock.scaleX = m.scaleX; 			mock.scaleY = m.scaleY; 				mock.scaleZ = m.scaleZ;
			return m2.clone(mock.transform);
		}
	}
}