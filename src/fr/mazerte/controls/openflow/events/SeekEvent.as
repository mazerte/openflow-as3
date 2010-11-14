/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.events
{
	import flash.events.Event;
	
	public class SeekEvent extends Event
	{
		public static const SEEK:String = "seek";
		public static const ROUNDED_SEEK:String = "roundedSeek";
		
		private var _seek:Number;
		private var _withAnim:Boolean;
		
		public function SeekEvent(type:String, pSeek:Number, pWithAnim:Boolean = true,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_seek = pSeek;
			_withAnim = pWithAnim;
			
			super(type, bubbles, cancelable);
		}
		
		public function get seek():Number
		{
			return _seek;
		}
		
		public function get withAnim():Boolean
		{
			return _withAnim;
		}
	}
}