using UnityEngine;
using System;

namespace WorldCurver{
	// public enum DistanceMethod {
	// 	Distance,
	// 	Plane
	// }

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
		[SerializeField]
		public Vector4 influence;
		[SerializeField]
		public DistanceMethod distanceMethod;
		/*	Internal.	*/
		[NonSerialized]
		private int m_CurveStrengthID;
		[NonSerialized]
		private int m_CurveHorizonID;
		[NonSerialized]
		private int m_CurveFadeDistID;
		[NonSerialized]
		private int m_CurvedDirectionID;
		[NonSerialized]
		private int m_CurveModeID;
		[NonSerialized]
		private int m_CurveInfluenceID;


		private void OnEnable()
		{
			/*	Get all global variable ID.	*/
			m_CurveStrengthID = Shader.PropertyToID("_CurveStrength");
			m_CurveHorizonID = Shader.PropertyToID("_Horizon");
			m_CurveFadeDistID = Shader.PropertyToID("_FadeDist");
			m_CurvedDirectionID = Shader.PropertyToID("_Direction");
			m_CurveModeID = Shader.PropertyToID("_CurveMode");
			m_CurveInfluenceID = Shader.PropertyToID("_LengthInfluence");

			/*	Update shaders.	*/
			updateAllGlobal();

			Shader.EnableKeyword("CURVED_ON");
		}

		private void OnDisable(){
			/*	Disable and reset to non curve.	*/
			Shader.SetGlobalFloat(m_CurveStrengthID, 0.0f);
			Shader.SetGlobalFloat(m_CurveHorizonID, 0.0f);
			Shader.SetGlobalFloat(m_CurveFadeDistID, 0.0f);
			Shader.SetGlobalVector(m_CurvedDirectionID, Vector4.zero);

			/*	Disable Curving.	*/
			Shader.DisableKeyword("CURVED_ON");
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
		
		private void updateAllGlobal()
		{
			Shader.SetGlobalFloat(m_CurveStrengthID, curveStrength * 0.001f);
			Shader.SetGlobalFloat(m_CurveHorizonID, curveHorizon);
			Shader.SetGlobalFloat(m_CurveFadeDistID, curveFadeDist);
			Shader.SetGlobalVector(m_CurvedDirectionID, direction);
			Shader.SetGlobalVector(m_CurveInfluenceID, influence);
			Shader.SetGlobalInt(m_CurveModeID, (int)curveSpace);
		}


# if UNITY_EDITOR
		private void Update()
		{
			updateAllGlobal();
		}

		void OnValidate()
		{
			this.influence.x = Mathf.Clamp(this.influence.x, 0, 1);
			this.influence.y = Mathf.Clamp(this.influence.y, 0, 1);
			this.influence.z = Mathf.Clamp(this.influence.z, 0, 1);
			this.influence.w = Mathf.Clamp(this.influence.w, 0, 1);


			this.direction.x = Mathf.Max(this.direction.x, 0);
			this.direction.y = Mathf.Max(this.direction.y, 0);
			this.direction.z = Mathf.Max(this.direction.z, 0);
			this.direction.w = Mathf.Max(this.direction.w, 0);
		}
#endif
	}
}
