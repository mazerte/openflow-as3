package fr.mazerte.controls.openflow.seek
{
	import fr.mazerte.controls.openflow.core.OpenFlowBase;

	public interface ISeeker
	{
		function init(openFlow:OpenFlowBase):void;
		function start(value:Number):void;
		function goto(value:Number):void;
	}
}