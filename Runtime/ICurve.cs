using UnityEngine;
using System;

namespace WorldCurver{

	public enum CurveSpace
	{
		[Tooltip("Curve using the clip space.")]
		ClipSpace,
		[Tooltip("Curve using world space.")]
		WorldSpace,
		[Tooltip("Curve using world space.")]
		ViewSpace,
	}

	public interface ICurve {
		/*	*/
		void setStrength(float strength);
		float getStrength();
		/*	*/
		void setDirection(Vector3 direction);
		Vector3 getDirection();
		/*	*/
		CurveSpace getSpace();
		void setSpace(CurveSpace space);
		/*	*/
		float getHorizonDistance();
		void setHorizonDistance(float horizon);
		/*	*/
		float getFadeHorizonDistance();
		void setFadeHorizonDistance(float fadeHorizon);
	}
}
