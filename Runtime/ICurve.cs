using UnityEngine;
using System;

namespace WorldCurver{

	public enum CurveSpace
	{
		/*	Curve using the clip space.	*/
		ClipSpace,
		/*	Curve using world space.	*/
		WorldSpace,
		/*	Curve using view space.	*/
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
