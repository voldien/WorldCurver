using UnityEngine;
using System;

namespace WorldCurver{

	[ExecuteInEditMode, AddComponentMenu("Curve/WorldCurver", 0)]
	public class WorldCurver : MonoBehaviour, ICurve
	{
		[SerializeField, Tooltip("Space that the curve will be performed.")]
		public CurveSpace curveSpace;
		[Range(-1f, 1f), SerializeField,Tooltip("The strength of the curve.")]
		public float curveStrength = 0.01f;
		[Range(-0.1f, 1000.0f), SerializeField,Tooltip("Distance from the horizon.")]
		public float curveHorizon = 1000.0f;
		[Range(-0.1f, 1000.0f), SerializeField,Tooltip("The transition inbetween the horizion.")]
		public float curveFadeDist = 10.0f;
		[SerializeField, Tooltip("The direction of the curvature in respect to the curve-space.")]
		public Vector4 direction = new Vector4(0.0f, 1.0f, 0.0f, 0.0f);

		[SerializeField, Tooltip("Use horizion.")]
		public bool horizon = true;
		[SerializeField, Tooltip("Use Horizon Transition fade.")]
		public bool fadeHorizontrue = true;
		/*	Internal.	*/
		[NonSerialized]
		private int m_CurveStrengthID;
		[NonSerialized]
		private int m_CurveHorizonID;
		[NonSerialized]
		private int m_CurveFadeDistID;
		[NonSerialized]
		private int m_CurvedDirectionID;
		private int m_CurveModeID;

		private void OnEnable()
		{
			m_CurveStrengthID = Shader.PropertyToID("_CurveStrength");
			m_CurveHorizonID = Shader.PropertyToID("_Horizon");
			m_CurveFadeDistID = Shader.PropertyToID("_FadeDist");
			m_CurvedDirectionID = Shader.PropertyToID("_Direction");
			m_CurveModeID = Shader.PropertyToID("_CurveMode");
			updateAllGlobal();
		}

		private void onDisable(){
			
		}
		public void setStrength(float strength)
		{
			this.curveStrength = strength;
			updateAllGlobal();
		}
		public float getStrength()
		{
			return this.curveStrength;
		}
		public void setDirection(Vector3 direction)
		{
			this.direction = direction;
			updateAllGlobal();
		}
		public Vector3 getDirection()
		{
			return new Vector3(direction.x, direction.y, direction.z);
		}

		public CurveSpace getSpace()
		{
			return this.curveSpace;
		}
		public void setSpace(CurveSpace space)
		{
			this.curveSpace = space;
			updateAllGlobal();
		}

		public float getHorizonDistance()
		{
			return this.curveHorizon;
		}
		public void setHorizonDistance(float horizon)
		{
			this.curveHorizon = horizon;
			updateAllGlobal();
		}

		public float getFadeHorizonDistance()
		{
			return this.curveHorizon;
		}
		public void setFadeHorizonDistance(float fadeHorizon)
		{
			this.curveFadeDist = fadeHorizon;
			updateAllGlobal();
		}
		public static string getSpaceKeyWord(CurveSpace curveSpace)
		{
			switch (curveSpace)
			{
				case CurveSpace.ClipSpace:
					return "CURVE_CLIPSPACE";
				case CurveSpace.WorldSpace:
					return "CURVE_WORLDSPACE";
				case CurveSpace.ViewSpace:
					return "CURVE_VIEWSPACE";
				default:
					throw new ArgumentException("Invalid Curve space.");
			}
		}

		private void updateAllGlobal()
		{
			Shader.SetGlobalFloat(m_CurveStrengthID, curveStrength * 0.001f);
			Shader.SetGlobalFloat(m_CurveHorizonID, curveHorizon);
			Shader.SetGlobalFloat(m_CurveFadeDistID, curveFadeDist);
			Shader.SetGlobalVector(m_CurvedDirectionID, direction);
			Shader.SetGlobalInt(m_CurveModeID, (int)curveSpace);
			Shader.EnableKeyword(getSpaceKeyWord(this.curveSpace));
		}

		private void Update()
		{
			//TODO remove to event based.
			updateAllGlobal();
		}
	}
}
