/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.utils.eaze
{	
	import aze.motion.EazeTween;
	import aze.motion.specials.EazeSpecial;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
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
			
			var klass:Class;
			switch(getQualifiedClassName(value))
			{
				case "away3d.core.math::MatrixAway3D": // Away3D
					klass = getDefinitionByName("fr.mazerte.controls.openflow.utils.eaze.transform3D::Away3DAdapter") as Class;
					break;
				case "flash.geom::Matrix3D": // Flash
					klass = getDefinitionByName("fr.mazerte.controls.openflow.utils.eaze.transform3D::Flash3DAdapter") as Class;
					break;
				case "org.papervision3d.core.math.Matrix3D": // Papervision
					klass = getDefinitionByName("fr.mazerte.controls.openflow.utils.eaze.transform3D::PapervisionAdapter") as Class;
					break;
			}
			if(klass)
				_adapter = new klass(target, property, value, next);
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