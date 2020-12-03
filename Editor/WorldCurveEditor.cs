using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace WorldCurver
{
	[CustomEditor(typeof(WorldCurver))]
	public class WorldCurveEditor : Editor
	{
		private SerializedProperty cam;
		private SerializedProperty curveSpace;
		private SerializedProperty curveStrength;
		private SerializedProperty curveHorizon;
		private SerializedProperty curveFadeDist;
		private SerializedProperty direction;
		private SerializedProperty horizon;
		private SerializedProperty fadeHorizontrue;
		private SerializedProperty influence;
		private SerializedProperty distanceMethod;

		private GUIContent m_style_CurveSpace;
		private GUIContent m_style_CurveStrength;
		private GUIContent m_style_CurveDirection;
		private GUIContent m_style_CurveInfluence;
		private GUIContent m_style_Curvehorizon;
		private GUIContent m_style_CurveFadehorizon;

		private void OnEnable()
		{
			fetchSerializeProperty();
		}

		private void fetchSerializeProperty()
		{
			this.cam = serializedObject.FindProperty("cam");
			this.curveSpace = serializedObject.FindProperty("m_curveSpace");
			this.curveStrength = serializedObject.FindProperty("m_curveStrength");
			this.curveHorizon = serializedObject.FindProperty("m_curveHorizon");
			this.curveFadeDist = serializedObject.FindProperty("m_curveFadeDist");
			this.direction = serializedObject.FindProperty("m_direction");
			this.horizon = serializedObject.FindProperty("m_horizon");
			this.fadeHorizontrue = serializedObject.FindProperty("m_fadeHorizontrue");
			this.influence = serializedObject.FindProperty("m_influence");
			this.distanceMethod = serializedObject.FindProperty("m_distanceMethod");
		}

		public override void OnInspectorGUI()
		{
			EditorGUILayout.LabelField("Camera Settings", EditorStyles.boldLabel);
			serializedObject.Update();
			EditorGUILayout.PropertyField(this.cam, new GUIContent("Camera", this.cam.tooltip));
			/*	*/
			EditorGUILayout.LabelField("Curve Settings", EditorStyles.boldLabel);
			EditorGUILayout.PropertyField(this.curveSpace, new GUIContent("Curve Space", this.curveSpace.tooltip));
			EditorGUILayout.PropertyField(this.curveStrength);

			/**/
			EditorGUILayout.LabelField("Curve Curve influence", EditorStyles.boldLabel);
			EditorGUILayout.PropertyField(this.direction);
			EditorGUILayout.PropertyField(this.influence);

			/*	*/
			EditorGUILayout.LabelField("Curve Horizon Settings", EditorStyles.boldLabel);
			EditorGUILayout.PropertyField(this.horizon);
			EditorGUILayout.PropertyField(this.fadeHorizontrue);
			EditorGUILayout.PropertyField(this.distanceMethod);

			/*	*/
			EditorGUILayout.PropertyField(this.curveHorizon);
			EditorGUILayout.PropertyField(this.curveFadeDist);

			serializedObject.ApplyModifiedProperties();
		}
	}
}