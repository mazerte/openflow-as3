/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.itemRenderer
{
	import flash.events.IEventDispatcher;

	public interface IItemRenderer extends IEventDispatcher
	{
		function setData(data:*):void;
		
		function focusIn():void;
		function focusOut():void;
		
		function rollOver():void;
		function rollOut():void;
		
		function dispose():void;
		
		//function get mouseEnable():Boolean;
		//function set mouseEnable(value:Boolean):void;
	}
}