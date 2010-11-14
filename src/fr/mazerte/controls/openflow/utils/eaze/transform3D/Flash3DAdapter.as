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
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	public class Flash3DAdapter extends EazeSpecial
	{		
		static public function register():void
		{
			EazeTween.specialProperties.transform3D = Flash3DAdapter;
		}
		
		private var _orig:Vector.<Number>;
		private var _start:Vector.<Number>;
		private var _delta:Vector.<Number>;
		private var vvalue:Matrix3D;
		
		public function Flash3DAdapter(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target, property, value, next);
			if(value is AbstractMatrix3D)
				vvalue = _convertMatrix(value as AbstractMatrix3D);
			else
				vvalue = value.clone();
		}
		
		override public function init(reverse:Boolean):void 
		{
			var st:Vector.<Number> = (Sprite(target).transform.matrix3D) ? Sprite(target).transform.matrix3D.clone().rawData : new Matrix3D().rawData;
			
			var end:Vector.<Number>;
			if (reverse) 
			{ 
				_start = vvalue.rawData; 
				end = st; 
			}
			else 
			{ 
				end = vvalue.rawData; 
				_start = st; 
			}
			
			_delta = new Vector.<Number>();
			_delta.push(
				end[0] 	- _start[0],
				end[1] 	- _start[1],
				end[2] 	- _start[2],
				end[3] 	- _start[3],
				end[4] 	- _start[4],
				end[5] 	- _start[5],
				end[6] 	- _start[6],
				end[7] 	- _start[7],
				end[8] 	- _start[8],
				end[9] 	- _start[9],
				end[10] - _start[10],
				end[11] - _start[11],
				end[12] - _start[12],
				end[13] - _start[13],
				end[14] - _start[14],
				end[15] - _start[15]
			);
		}
		
		override public function update(ke:Number, isComplete:Boolean):void 
		{
			var v:Vector.<Number> = new Vector.<Number>();
			v.push(
				_start[0] 	+ (_delta[0] * ke),
				_start[1] 	+ (_delta[1] * ke),
				_start[2] 	+ (_delta[2] * ke),
				_start[3] 	+ (_delta[3] * ke),
				_start[4] 	+ (_delta[4] * ke),
				_start[5] 	+ (_delta[5] * ke),
				_start[6] 	+ (_delta[6] * ke),
				_start[7] 	+ (_delta[7] * ke),
				_start[8] 	+ (_delta[8] * ke),
				_start[9] 	+ (_delta[9] * ke),
				_start[10] 	+ (_delta[10] * ke),
				_start[11] 	+ (_delta[11] * ke),
				_start[12] 	+ (_delta[12] * ke),
				_start[13] 	+ (_delta[13] * ke),
				_start[14] 	+ (_delta[14] * ke),
				_start[15] 	+ (_delta[15] * ke)
			);

			Sprite(target).transform.matrix3D = new Matrix3D(v);
		}
		
		private function _convertMatrix(m:AbstractMatrix3D):Matrix3D
		{
			var mock:Sprite = new Sprite();
			mock.x = m.x;					mock.y = m.y; 					mock.z = m.z;
			mock.rotationX = m.rotationX; 	mock.rotationY = m.rotationY; 	mock.rotationZ = m.rotationZ;
			mock.scaleX = m.scaleX; 		mock.scaleY = m.scaleY; 		mock.scaleZ = m.scaleZ;
			return mock.transform.matrix3D.clone();
		}
	}
}