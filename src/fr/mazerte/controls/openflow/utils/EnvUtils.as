package fr.mazerte.controls.openflow.utils
{
	import flash.display.Sprite;
	import flash.utils.describeType;
	
	import fr.mazerte.controls.openflow.error.EnvError;

	public class EnvUtils
	{
		public static const FLASH_3D:String = "Flash3D";
		public static const AWAY_3D:String = "Away3D";
		public static const PAPERVISION_3D:String = "Papervision3D";
		
		public static function getEnv(object:*):String
		{
			switch(true)
			{
				case object is Sprite:
					return FLASH_3D;
				case objectIsExtendsOf(object, "org.papervision3d.core.geom::TriangleMesh3D"):
					return AWAY_3D;
				case objectIsExtendsOf(object, "away3d.core.base::Mesh"):
					return PAPERVISION_3D;
				default:
					throw new EnvError(FLASH_3D + "/" + AWAY_3D + "/" + PAPERVISION_3D);
			}
			return null;
		}
		
		public static function objectIsExtendsOf(object:*, qualifiedClassName:String):Boolean
		{
			var description:XML = describeType(object);
			for each(var klass:XML in description..extendsClass)
			{
				if(klass.@type == qualifiedClassName)
					return true;
			}
			return false
		}
	}
}