using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace WorldCurver
{
	[CustomEditor(typeof(WorldCurver))]
	public class WorldCurveEditor : Editor
	{
		private SerializedProperty curveSpace;
		private SerializedProperty curveStrength;
		private SerializedProperty curveHorizon;
		private SerializedProperty curveFadeDist;
		private SerializedProperty direction;
		private SerializedProperty horizon;
		private SerializedProperty fadeHorizontrue;
		private SerializedProperty influence;

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
			this.curveSpace = serializedObject.FindProperty("curveSpace");
			this.curveStrength = serializedObject.FindProperty("curveStrength");
			this.curveHorizon = serializedObject.FindProperty("curveHorizon");
			this.curveFadeDist = serializedObject.FindProperty("curveFadeDist");
			this.direction = serializedObject.FindProperty("direction");
			this.horizon = serializedObject.FindProperty("horizon");
			this.fadeHorizontrue = serializedObject.FindProperty("fadeHorizontrue");
			this.influence = serializedObject.FindProperty("influence");
		}

		public override void OnInspectorGUI()
		{
			serializedObject.Update();

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

			/*	*/
			EditorGUILayout.PropertyField(this.curveHorizon);
			EditorGUILayout.PropertyField(this.curveFadeDist);

			serializedObject.ApplyModifiedProperties();
		}
	}
}