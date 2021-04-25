using UnityEngine;
using System;

namespace WorldCurver {

	public enum DistanceMethod {
		/*	*/
		Distance = 0,
		/*	*/
		Plane = 1,
		Curve = 2,
	}

	/// <summary>
	/// 
	/// </summary>
	public enum DirectionMethod {
		Custom,
		Camera,
	}

	[ExecuteInEditMode, AddComponentMenu("Curve/WorldCurver", 0)]
	public class WorldCurver : MonoBehaviour, ICurve
	{
		[SerializeField, Tooltip("Camera the world is associated with.")]
		public Camera cam;
		[SerializeField, Tooltip("Space that the curve will be performed.")]
		public CurveSpace m_curveSpace;
		[Range(-1f, 1f), SerializeField,Tooltip("The strength of the curve.")]
		public float m_curveStrength = 0.01f;
		[Range(-0.1f, 1000.0f), SerializeField,Tooltip("Distance from the horizon.")]
		public float m_curveHorizon = 1000.0f;
		[Range(-0.1f, 1000.0f), SerializeField,Tooltip("The transition inbetween the horizion.")]
		public float m_curveFadeDist = 10.0f;
		[SerializeField, Tooltip("The direction of the curvature in respect to the curve-space.")]
		public Vector3 m_direction = new Vector3(0.0f, 1.0f, 0.0f);

		[SerializeField, Tooltip("Use horizion.")]
		public bool m_horizon = true;
		[SerializeField, Tooltip("Use Horizon Transition fade.")]
		public bool m_fadeHorizontrue = true;
		[SerializeField]
		public Vector4 m_influence = new Vector4(1.0f,1.0f,1.0f, 0.0f);
		[SerializeField]
		public DistanceMethod m_distanceMethod;
		[SerializeField,Tooltip("")]
		public float mag = 20;
		[SerializeField, Tooltip("")]
		public DirectionMethod m_directionMethod;
		public AnimationCurve animationCurve;

		[NonSerialized]
		private Vector3 cam_dir;

		/*	Internal property IDs.	*/
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

			/*	Enable the curved variation.	*/
			Shader.EnableKeyword("CURVED_ON");
		}

		private void OnDisable()
		{
			/*	Disable and reset to non curve.	*/
			Shader.SetGlobalFloat(m_CurveStrengthID, 0.0f);
			Shader.SetGlobalFloat(m_CurveHorizonID, 0.0f);
			Shader.SetGlobalFloat(m_CurveFadeDistID, 0.0f);
			Shader.SetGlobalVector(m_CurvedDirectionID, Vector4.zero);

			/*	Disabled the curved variation.	*/
			Shader.DisableKeyword("CURVED_ON");
		}

		public void GetCamera(Camera camera){
			this.cam = camera;
		}
		public Camera GetCamera(){
			return this.cam;
		}

		public void setStrength(float strength)
		{
			this.m_curveStrength = strength;
			updateAllGlobal();
		}

		public float getStrength()
		{
			return this.m_curveStrength;
		}

		public void setDirection(Vector3 direction)
		{
			this.m_direction = direction;
			updateAllGlobal();
		}
		
		public Vector3 getDirection()
		{
			return new Vector3(m_direction.x, m_direction.y, m_direction.z);
		}

		public CurveSpace getSpace()
		{
			return this.m_curveSpace;
		}
		public void setSpace(CurveSpace space)
		{
			this.m_curveSpace = space;
			updateAllGlobal();
		}

		public float getHorizonDistance()
		{
			return this.m_curveHorizon;
		}
		public void setHorizonDistance(float horizon)
		{
			this.m_curveHorizon = horizon;
			updateAllGlobal();
		}

		public float getFadeHorizonDistance()
		{
			return this.m_curveHorizon;
		}
		public void setFadeHorizonDistance(float fadeHorizon)
		{
			this.m_curveFadeDist = fadeHorizon;
			updateAllGlobal();
		}

		public void setMatrixTransition(Matrix4x4[] mats){
			
		}
		
		private void updateAllGlobal()
		{
			Shader.SetGlobalFloat(m_CurveStrengthID, m_curveStrength * 0.001f);
			Shader.SetGlobalFloat(m_CurveHorizonID, m_curveHorizon);
			Shader.SetGlobalFloat(m_CurveFadeDistID, m_curveFadeDist);
			switch (this.m_directionMethod)
			{
				case DirectionMethod.Camera:
				Shader.SetGlobalVector(m_CurvedDirectionID, cam_dir);
				Debug.Log(cam_dir);
				 break;
				default:
			Shader.SetGlobalVector(m_CurvedDirectionID, m_direction);
				break;
			}
			Shader.SetGlobalVector(m_CurveInfluenceID, m_influence);
			Shader.SetGlobalInt(m_CurveModeID, (int)m_curveSpace);
		}

		[ExecuteInEditMode]
		private void Update()
		{
			updateAllGlobal();
			switch(this.m_directionMethod){
				case DirectionMethod.Camera:
					this.cam_dir = this.cam.transform.TransformDirection(m_direction).normalized;
					break;
				case DirectionMethod.Custom:
					break;
			}

		}
#if UNITY_EDITOR
		void OnValidate()
		{
			// this.m_influence.x = Mathf.Clamp(this.m_influence.x, 0, 1);
			// this.m_influence.y = Mathf.Clamp(this.m_influence.y, 0, 1);
			// this.m_influence.z = Mathf.Clamp(this.m_influence.z, 0, 1);
			// this.m_influence.w = Mathf.Clamp(this.m_influence.w, 0, 1);


			// this.m_direction.x = Mathf.Max(this.m_direction.x, 0);
			// this.m_direction.y = Mathf.Max(this.m_direction.y, 0);
			// this.m_direction.z = Mathf.Max(this.m_direction.z, 0);
			//this.m_direction.w = Mathf.Max(this.m_direction.w, 0);
		}
#endif
	}
}
