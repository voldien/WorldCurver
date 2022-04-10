using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using System;


namespace Curves
{
	[CustomEditor(typeof(BeizerCurve)), CanEditMultipleObjects]
	public class BeizerCurveEditor : Editor
	{
		static int s_DragHandleHash = "DragHandleHash".GetHashCode();
		static int s_DragHandleClickID;

		private SerializedProperty _property;
		private SerializedProperty _cyclic;
		private ReorderableList _list;

		public void OnSceneGUI()
		{
			if (Event.current.type == EventType.Repaint)
			{
				Handles.color = Color.white;
				BeizerCurve curve = (BeizerCurve)this.target;
				DrawBezierCurve(curve);
			}
		}

		void OnEnable()
		{
			_cyclic = serializedObject.FindProperty("Cyclic");
			_property = serializedObject.FindProperty("controlPoints");
			_list = new ReorderableList(serializedObject, _property, true, true, true, true)
			{
				drawHeaderCallback = DrawListHeader,
				drawElementCallback = DrawListElement,
				onAddCallback = AddControlElement,
				onRemoveCallback = RemoveControlElement,
				elementHeightCallback = getElementHeight,

			};
			SceneView.duringSceneGui += OnSceneViewGUI;
		}

		private float getElementHeight(int index)
		{
			return 45.0f;
		}

		private void RemoveControlElement(ReorderableList list)
		{
			BeizerCurve curve = (BeizerCurve)this.target;
			curve.controlPoints.RemoveAt(list.index);
		}

		private void AddControlElement(ReorderableList list)
		{
			//list.defaultBehaviours
			BeizerCurve curve = (BeizerCurve)this.target;
			ControlPoint newPoint = new ControlPoint();
			if (curve.controlPoints.Count > 0)
				newPoint.position = curve.controlPoints[curve.controlPoints.Count - 1].position + Vector3.one * 4.0f;
			curve.appendControlPoint(new ControlPoint());
			/*	Make sure that the control point is created offset from the adjecent control point in the sequence.	*/
		}
		private void DrawListHeader(Rect rect)
		{
			GUI.Label(rect, "Control Points");
		}

		private void DrawListElement(Rect rect, int index, bool isActive, bool isFocused)
		{
			var item = _property.GetArrayElementAtIndex(index);
			var position = item.FindPropertyRelative("position");
			var Tin = item.FindPropertyRelative("localStartTangent");
			var Tout = item.FindPropertyRelative("localEndTangent");

			int vecWidth = 140;
			int textWidth = 80;

			/*	*/
			EditorGUI.LabelField(new Rect(rect.x + 0, rect.y, textWidth, EditorGUIUtility.singleLineHeight), "Position");
			EditorGUI.PropertyField(
			new Rect(rect.x + 60, rect.y, vecWidth, EditorGUIUtility.singleLineHeight),
			position,
			GUIContent.none
			);

			/*	*/
			EditorGUI.LabelField(new Rect(rect.x + 210, rect.y, textWidth, EditorGUIUtility.singleLineHeight), "Tin");
			EditorGUI.PropertyField(
			new Rect(rect.x + 260, rect.y, vecWidth, EditorGUIUtility.singleLineHeight),
			Tin,
			GUIContent.none
			);

			/*	*/
			EditorGUI.LabelField(new Rect(rect.x + 410, rect.y, textWidth, EditorGUIUtility.singleLineHeight), "Tout");
			EditorGUI.PropertyField(
			new Rect(rect.x + 455, rect.y, vecWidth, EditorGUIUtility.singleLineHeight),
			Tout,
			GUIContent.none
			);
		}

		void OnDisable()
		{
			SceneView.duringSceneGui -= OnSceneViewGUI;
		}

		private void OnSceneViewGUI(SceneView sv)
		{
			BeizerCurve curve = (BeizerCurve)this.target;

			//TODO relocate to different method.
			int id = GUIUtility.GetControlID(s_DragHandleHash, FocusType.Passive);
			//Vector3 screenPosition = Handles.matrix.MultiplyPoint(position);

			switch (Event.current.GetTypeForControl(id))
			{
				case EventType.MouseDown:
					if (HandleUtility.nearestControl == id && (Event.current.button == 0 || Event.current.button == 1))
					{
						GUIUtility.hotControl = id;

						Event.current.Use();
						EditorGUIUtility.SetWantsMouseJumping(1);

						// if (Event.current.button == 0)
						// 	result = DragHandleResult.LMBPress;
						// else if (Event.current.button == 1)
						// 	result = DragHandleResult.RMBPress;
					}
					break;
				case EventType.MouseUp:
					if (GUIUtility.hotControl == id && (Event.current.button == 0 || Event.current.button == 1))
					{
						GUIUtility.hotControl = 0;
						Event.current.Use();
						EditorGUIUtility.SetWantsMouseJumping(0);


					}
					break;
				case EventType.MouseMove:
					break;
				case EventType.MouseDrag:
					if (GUIUtility.hotControl == id)
					{

						Vector2 t = new Vector2(Event.current.delta.x, -Event.current.delta.y);


						GUI.changed = true;
						Event.current.Use();
					}
					break;
				case EventType.Repaint:
					Color currentColor = Handles.color;
					if (id == GUIUtility.hotControl && false)
						Handles.color = Color.red;

					Handles.color = Color.white;
					break;
				case EventType.Layout:
					Handles.matrix = Matrix4x4.identity;
					//HandleUtility.AddControl(id, HandleUtility.DistanceToCircle())

					break;
				default:
					break;
			}

			// if (HandleUtility.nearestControl == controlId && e.button == 0)
			// {
			// 	GUIUtility.hotControl = controlId;
			// 	GUIUtility.keyboardControl = controlId;
			// 	e.Use();
			// }

		}


		[DrawGizmo(GizmoType.NotInSelectionHierarchy)]
		static void RenderCustomGizmo(BeizerCurve curve, GizmoType gizmoType)
		{
			DrawBezierCurve(curve);
		}

		static private void DrawBezierCurve(BeizerCurve curve)
		{
			float lineThickness = 2.0f;
			Color curveColor = Color.white;

			/*	Draw curbe between each control point.	*/
			for (int i = 1; i < curve.controlPoints.Count; i++)
			{
				ControlPoint prev = curve.controlPoints[i - 1];
				ControlPoint cur = curve.controlPoints[i];
				if (prev != null && cur != null)
				{
					Handles.DrawBezier(prev.position, cur.position,
						prev.position + prev.localStartTangent, cur.position + cur.localEndTangent,
						curveColor, null, lineThickness);
				}
			}
			/*	Draw final loop curve segement.	*/
			if (curve.Cyclic)
			{
				ControlPoint prev = curve.controlPoints[curve.controlPoints.Count - 1];
				ControlPoint cur = curve.controlPoints[0];
				Handles.DrawBezier(prev.position, cur.position,
				prev.position + prev.localStartTangent, cur.position + cur.localEndTangent,
				curveColor, null, lineThickness);
			}

			/*	Draw tangent line and control point nam.	*/
			for (int i = 0; i < curve.controlPoints.Count; i++)
			{
				ControlPoint cur = curve.controlPoints[i];
				if (cur != null)
				{
					Handles.DrawLine(cur.position, cur.position + cur.localStartTangent);
					Handles.DrawLine(cur.position, cur.position + cur.localEndTangent);
					Handles.Label(cur.position, "V" + i.ToString());
				}
			}

			//Handles.CubeHandleCap

			// for (int i = 1; i < curve.controlPoints.Length; i++)
			// {
			// 	ControlPoint prev = curve.controlPoints[i - 1];
			// 	ControlPoint cur = curve.controlPoints[i];
			// 	if (prev && cur)
			// 	{
			// 		Handles.DrawDottedLines(computeLineBetweenPoints(curve, prev, cur), 2.0f);
			// 	}
			// }
		}

		static private void DrawBeizerTangentControlPoints(BeizerCurve curve)
		{
			if (curve.controlPoints.Count > 0)
			{
				for (int i = 1; i < curve.controlPoints.Count; i++)
				{
					ControlPoint prev = curve.controlPoints[i - 1];
					ControlPoint cur = curve.controlPoints[i];
					if (prev != null && cur != null)
					{

						Handles.color = Color.magenta;
						EditorGUI.BeginChangeCheck();

						Vector3 prevStart = Handles.PositionHandle(prev.position + prev.localStartTangent, Quaternion.identity) - prev.position;
						Vector3 curEnd = Handles.PositionHandle(cur.position + cur.localEndTangent, Quaternion.identity) - cur.position;

						if (EditorGUI.EndChangeCheck())
						{
							Undo.RecordObject(curve, "Changed Control Point Tangent");
							prev.localStartTangent = prevStart;
							cur.localEndTangent = curEnd;
						}
					}
				}
			}
		}

		public override void OnInspectorGUI()
		{
			serializedObject.Update();
			EditorGUILayout.Space();
			EditorGUILayout.BeginVertical();
			EditorGUILayout.PropertyField(_cyclic);

			_list.DoLayoutList();
			EditorGUILayout.EndVertical();
			serializedObject.ApplyModifiedProperties();
		}
	}
}