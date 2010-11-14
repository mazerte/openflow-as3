/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.env
{
	import flash.events.Event;
	
	public class EnvEvent extends Event
	{
		public static const SEEK:String = "env_seek"
		
		private static var _seek:Number;
			
		public function EnvEvent(type:String, params:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			switch(type)
			{
				case SEEK:
					_seek = Number(params);
					break;
			}
			
			super(type, bubbles, cancelable);
		}
				
		public function get seek():Number
		{
			return _seek;
		}
	}
}