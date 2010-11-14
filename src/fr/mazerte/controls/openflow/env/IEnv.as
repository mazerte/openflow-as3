/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.env
{
	import flash.events.IEventDispatcher;
	
	import fr.mazerte.controls.openflow.interpolator.IInterpolator;
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	import fr.mazerte.controls.openflow.layout.ILayout;
	import fr.mazerte.controls.openflow.seek.ISeeker;

	public interface IEnv extends IEventDispatcher
	{
		function init(layout:ILayout, interpolators:Array):void;
		
		function update():void;
		
		function addItem(item:IItemRenderer, seek:Number, index:int, withAnim:Boolean = true):void;
		function removeItem(item:IItemRenderer, withAnim:Boolean = true):void;
		
		function setSeek(seek:Number, withAnim:Boolean = true):void;
		
		function resize(width:Number, height:Number):void;
		
		function get layout():ILayout;
		function set layout(l:ILayout):void;
		
		function get interpolators():Array;
		function set interpolators(a:Array):void;
		
		function dispose():void;
	}
}