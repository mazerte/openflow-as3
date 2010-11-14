/*	
OpenFlow as3 library for coverflow by Mathieu Desvé
Contact: mathieu.desve(at)me.com
License: http://www.opensource.org/licenses/mit-license.php
CopyRight: 2010
*/
package fr.mazerte.controls.openflow.error
{
	public class EnvError extends Error
	{
		public function EnvError(message:*="", id:*=0)
		{
			super(message + " environment required !", id);
		}
	}
}