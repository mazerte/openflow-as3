/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.itemRenderer
{
	public interface IItemRenderer
	{
		function setData(data:*):void;
		function focusIn():void;
		function focusOut():void;
		function dispose():void;
	}
}