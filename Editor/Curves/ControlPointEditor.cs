// using UnityEngine;
// using UnityEditor;

// [CustomEditor(typeof(ControlPoint)), CanEditMultipleObjects]
// public class ControlPointEditor : Editor
// {

// 	void OnEnable()
// 	{
// 		SceneView.duringSceneGui += OnSceneViewGUI;
// 	}
// 	void OnDisable()
// 	{
// 		SceneView.duringSceneGui -= OnSceneViewGUI;
// 	}


// 	private void OnSceneViewGUI(SceneView sv)
// 	{
// 		ControlPoint control = (ControlPoint)this.target;
// 		DrawBeizerTangentControlPoint(control);
// 	}

// 	void DrawBeizerTangentControlPoint(ControlPoint control)
// 	{
// 		Handles.color = Color.magenta;
// 		EditorGUI.BeginChangeCheck();

// 		Vector3 prevStart = Handles.PositionHandle(control.transform.position + control.startTangent, Quaternion.identity) - control.transform.position;
// 		Vector3 curEnd = Handles.PositionHandle(control.transform.position + control.endTangent, Quaternion.identity) - control.transform.position;

// 		if (EditorGUI.EndChangeCheck())
// 		{
// 			Undo.RecordObject(control, "Changed Tangent");
// 			control.startTangent = prevStart;
// 			control.endTangent = curEnd;
// 		}
// 	}
// 	public void OnSceneGUI()
// 	{
// 	}
// 	public override void OnInspectorGUI()
// 	{
// 		base.OnInspectorGUI();

// 	}
// }