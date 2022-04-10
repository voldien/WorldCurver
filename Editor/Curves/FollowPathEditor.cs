using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace Curves{
	[CustomEditor(typeof(FollowPath))]
	public class FollowPathEditor : Editor
	{

		SerializedProperty Lock;
		private bool foldOut = true;
		private void OnEnable()
		{
			fetchSerializeProperty();
		}

		private void fetchSerializeProperty()
		{
			Lock = serializedObject.FindProperty("Lock");
		}

		public override void OnInspectorGUI()
		{
			EditorGUILayout.BeginHorizontal();
			if (GUILayout.Button(new GUIContent("Activate", "")))
			{
				Undo.IncrementCurrentGroup();
				Undo.SetCurrentGroupName("Set Chess Pieces");
				var undoGroupIndex = Undo.GetCurrentGroup();
				FollowPath path = (FollowPath)serializedObject.targetObject;
				Undo.RecordObject(path.transform, "");
				path.setFollowMode(path.follow);

				Undo.CollapseUndoOperations(undoGroupIndex);
			}
			if (GUILayout.Button(new GUIContent("Zero", "")))
			{
				Undo.IncrementCurrentGroup();
				Undo.SetCurrentGroupName("Set Chess Pieces");
				var undoGroupIndex = Undo.GetCurrentGroup();

				Undo.CollapseUndoOperations(undoGroupIndex);
			}
			EditorGUILayout.EndHorizontal();

			/*	Freeze.	*/
			EditorGUI.BeginDisabledGroup(!Lock.boolValue);
			EditorGUILayout.BeginFoldoutHeaderGroup(foldOut, "");
			EditorGUILayout.EndFoldoutHeaderGroup();

			EditorGUI.EndDisabledGroup();


			EditorGUILayout.Space();

			base.OnInspectorGUI();
		}
	}
}