/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow
{
	import fr.mazerte.controls.openflow.seek.ISeeker;
	import fr.mazerte.controls.openflow.core.OpenFlowBase;
	import fr.mazerte.controls.openflow.env.IEnv;
	import fr.mazerte.controls.openflow.layout.ILayout;
	
	public class OpenFlow extends OpenFlowBase
	{
		public function OpenFlow(data:Array=null, itemRenderer:Class=null, env:IEnv=null, layout:ILayout=null, interpolators:Array=null, seeker:ISeeker = null)
		{
			super(data, itemRenderer, env, layout, interpolators, seeker);
		}
	}
}