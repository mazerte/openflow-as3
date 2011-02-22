/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.interpolator
{
	import fr.mazerte.controls.openflow.utils.AbstractMatrix3D;

	public interface IInterpolator
	{
		function setSize(width:Number, height:Number):void;
		function setLength(len:int):void;
		function addInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number;
		function moveInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number;
		function overInterpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number;
		function interpolationItem(item:*, transform:AbstractMatrix3D, index:Number, seek:Number):Number;
		function removeInterpolationItem(item:*, index:Number, seek:Number):Number;
		function dispose():void;
	}
}