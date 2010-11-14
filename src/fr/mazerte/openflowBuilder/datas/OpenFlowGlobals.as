package fr.mazerte.openflowBuilder.datas
{
	[Bindable]
	public class OpenFlowGlobals
	{
		private static var _instance:OpenFlowGlobals;
		
		public function OpenFlowGlobals()
		{
			if(!_instance)
				_instance = this
			else
				throw new Error("Singleton Error");
		}
		
		public static function getInstance():OpenFlowGlobals
		{
			if(!_instance)
				_instance = new OpenFlowGlobals();
			return _instance;
		}
		
		
		public var itemWidth:Number = 444;
		public var itemHeight:Number = 326;
		public var itemAlpha:Number = 1;
	}
}