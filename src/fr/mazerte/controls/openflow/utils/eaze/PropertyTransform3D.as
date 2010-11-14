/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.utils.eaze
{
	import away3d.core.base.Object3D;
	import away3d.core.math.MatrixAway3D;
	
	import aze.motion.EazeTween;
	import aze.motion.specials.EazeSpecial;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.Flash3DAdapter;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.Away3DAdapter;
	import fr.mazerte.controls.openflow.utils.eaze.transform3D.PapervisionAdapter;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class PropertyTransform3D extends EazeSpecial
	{
		static public function register():void
		{
			EazeTween.specialProperties.transform3D = PropertyTransform3D;
		}
		
		private var _adapter:EazeSpecial;
		
		public function PropertyTransform3D(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target, property, value, next);
			
			switch(true)
			{
				case value is MatrixAway3D: // Away3D
					_adapter = new Away3DAdapter(target, property, value, next);
					break;
				case value is flash.geom.Matrix3D: // Flash
					_adapter = new Flash3DAdapter(target, property, value, next);
					break;
				case value is org.papervision3d.core.math.Matrix3D: // Papervision
					_adapter = new PapervisionAdapter(target, property, value, next);
					break;
			}
		}
		
		override public function init(reverse:Boolean):void 
		{
			_adapter.init(reverse)
		}
		
		override public function update(ke:Number, isComplete:Boolean):void 
		{
			_adapter.update(ke, isComplete);
		}
	}
}