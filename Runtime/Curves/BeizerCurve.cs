using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Curves{
public class BeizerCurve : MonoBehaviour
{
	[SerializeField]
	public List<ControlPoint> controlPoints = new List<ControlPoint>();
	[SerializeField, Tooltip("Cyclic")]
	public bool Cyclic;
	public int NrSegments { get { return this.controlPoints.Count - 1; } }

	public Vector3 GetPosition(ControlPoint a, ControlPoint b, float t)
	{
		return BeizerCurve.GetPosition_(a, b, t);
	}

	public Vector3 GetTangent(ControlPoint a, ControlPoint b, float t)
	{
		return BeizerCurve.GetTangent_(a, b, t);
	}

	public Vector3 GetTangent(int nsegment, float t)
	{
		int ai = nsegment - 1;
		int bi = nsegment;
		ControlPoint a = controlPoints[ai];
		ControlPoint b = controlPoints[bi];
		return BeizerCurve.GetTangent_(a, b, t);
	}

	public Vector3 GetSecondDerivative(ControlPoint a, ControlPoint b, float t)
	{
		return BeizerCurve.GetSecondDerivative_(a, b, t);
	}

	public Vector3 GetSecondDerivative(int nsegment, float t)
	{
		int ai = nsegment - 1;
		int bi = nsegment;
		ControlPoint a = controlPoints[ai];
		ControlPoint b = controlPoints[bi];
		return BeizerCurve.GetSecondDerivative_(a, b, t);
	}

	public Vector3 GetPosition(int nsegment, float t)
	{
		/*	Compute control point index.	*/
		int ai = nsegment - 1;
		int bi = nsegment;
		ControlPoint a = controlPoints[ai];
		ControlPoint b = controlPoints[bi];
		return BeizerCurve.GetPosition_(a, b, t);
	}

	public void insertControlPoint(int index, ControlPoint[] controlPoints)
	{
		this.controlPoints.InsertRange(index, controlPoints);
	}

	public void appendControlPoint(ControlPoint controlPoint)
	{
		this.controlPoints.Add(controlPoint);
	}

	public void appendControlPoint(ControlPoint[] controlPoints)
	{
		this.controlPoints.AddRange(controlPoints);
	}

	public void setControlPoints(ControlPoint[] controlPoints)
	{
		this.controlPoints = new List<ControlPoint>(controlPoints);
	}
	public void removeControlPoint(int index)
	{
		this.controlPoints.Remove(this.controlPoints[index]);
	}
	public void removeControlPointRange(int s, int e)
	{
		this.controlPoints.RemoveRange(s, e);
	}

	public ControlPoint getControlPoint(int index)
	{
		return this.controlPoints[index];
	}

	public static Vector3 GetPosition_(ControlPoint a, ControlPoint b, float t)
	{
		Vector3 aStartTangent = a.tangentStart;
		Vector3 bEndTangent = b.tangentEnd;

		return Mathf.Pow(1.0f - t, 3) * a.position
		 + 3.0f * Mathf.Pow(1.0f - t, 2) * t * aStartTangent
		+ 3.0f * (1.0f - t) * Mathf.Pow(t, 2) * bEndTangent
		 + Mathf.Pow(t, 3) * b.position;
	}

	public static Vector3 GetTangent_(ControlPoint a, ControlPoint b, float t)
	{
		Vector3 wAstartTangent = a.tangentStart;
		Vector3 wbEndTangent = a.localEndTangent;

		return 3.0f * Mathf.Pow(1.0f - t, 2) * (wAstartTangent - a.position)
		  + 6.0f * (1.0f - t) * t * (wbEndTangent - a.position)
		  + 3.0f * Mathf.Pow(t, 2) * (b.position - wbEndTangent);
	}

	public static Vector3 GetSecondDerivative_(ControlPoint a, ControlPoint b, float t)
	{
		Vector3 wAstartTangent = a.tangentStart;
		Vector3 wbEndTangent = a.localEndTangent;

		return 6.0f * (1.0f - t) * (b.position - 2.0f * wAstartTangent + a.position)
		+ 6.0f * t * (wbEndTangent - 2.0f * b.position + wAstartTangent);
	}
}

}