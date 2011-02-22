/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.layout
{
	import flash.events.IEventDispatcher;
	
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;
	
	[Event(name="change", type="flash.events.Event")]

	public interface ILayout extends IEventDispatcher
	{
		function setSize(width:Number, height:Number):void;
		function setLength(len:int):void;
		function getPostion(index:int, seek:Number):AbstractMatrix3D;
		function getRollOverPostion(index:int, seek:Number, rollIndex:int):AbstractMatrix3D;
		function dispose():void;
	}
}