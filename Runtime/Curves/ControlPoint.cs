using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Curves
{

	[Serializable]
	public class ControlPoint
	{
		[SerializeField, Tooltip("")]
		public Vector3 position;
		[SerializeField, Tooltip("")]
		public Vector3 localStartTangent = Vector3.left;
		[SerializeField, Tooltip("")]
		public Vector3 localEndTangent = Vector3.right;

		public Vector3 tangentEnd { get { return this.position + localEndTangent; } }
		public Vector3 tangentStart { get { return this.position + localStartTangent; } }

		private void OnDrawGizmos()
		{
			/*	Draw control-point.	*/
			Gizmos.color = Color.white;
			Gizmos.DrawWireCube(this.position, Vector3.one);

			/*	Draw tangent line.	*/
			Gizmos.color = Color.red;
			Gizmos.DrawLine(this.position, this.position + localStartTangent);
			Gizmos.color = Color.blue;
			Gizmos.DrawLine(this.position, this.position + localEndTangent);
		}
	}
}
