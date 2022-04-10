using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Curves
{

	public class IBezierCurve
	{
		[SerializeField, Tooltip("Cyclic")]
		public bool Cyclic;
		//public int NrSegments { get { return this.controlPoints.Count - 1; } }


		// public Vector3 GetPosition(ControlPoint a, ControlPoint b, float t);
		// public Vector3 GetTangent(ControlPoint a, ControlPoint b, float t);
		// public Vector3 GetTangent(int nsegment, float t);
		// public Vector3 GetSecondDerivative(ControlPoint a, ControlPoint b, float t);
		// public Vector3 GetSecondDerivative(int nsegment, float t);
		// public Vector3 GetPosition(int nsegment, float t);
	}
}