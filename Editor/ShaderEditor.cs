using UnityEngine;
using UnityEditor;

public class ShaderEditor : MaterialEditor {

	public override void OnInspectorGUI()
	{

		serializedObject.Update();
		SerializedProperty matShader = serializedObject.FindProperty("m_Shader");

		if (!isVisible)
			return;

		Material mat = target as Material;
		MaterialProperty Glossiness = GetMaterialProperty(new Object[] { mat }, "_Glossiness");

		if (Glossiness == null)
			return;

		EditorGUI.BeginChangeCheck();

		RangeProperty(Glossiness, "Glossiness");

		if (EditorGUI.EndChangeCheck())
			PropertiesChanged();
		base.OnInspectorGUI();
	}

}