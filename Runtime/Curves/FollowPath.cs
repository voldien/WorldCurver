using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Curves
{

	//TODO rename class to something about constraints
	[ExecuteInEditMode]
	public class FollowPath : MonoBehaviour
	{
		public enum FollowMode
		{
			BetweenT,
			SnapClosetPoint,
		}
		public enum Space
		{
			LocalSpace,
			WorldSpace,

		}

		[SerializeField, Tooltip("")]
		public BeizerCurve Curve;
		[SerializeField, Tooltip("")]
		public Transform target;
		[SerializeField, Tooltip("")]
		public Space space;
		[SerializeField, Tooltip("")]
		public FollowMode follow;   //TODO make private and add property to encupsalte.
		[SerializeField, Range(0, 1), Tooltip("")]

		public float weight;
		[SerializeField, Tooltip("")]
		public float offset;
		[SerializeField, Tooltip("")]
		[Header("")]
		public bool Lock = false;
		[SerializeField, Tooltip("")]

		public bool FreezeX;
		[SerializeField, Tooltip("")]
		public bool FreezeY;
		[SerializeField, Tooltip("")]
		public bool FreezeZ;
		public ControlPoint a, b;   //TODO change to private

		private void Awake()
		{
			setFollowMode(this.follow);
		}


		public void setFollowMode(FollowMode mode)
		{
			switch (mode)
			{
				case FollowMode.SnapClosetPoint:
					getClosestControlPoints(this.target, out a, out b);
					this.target.transform.position = a.position;
					this.follow = mode;
					break;
				case FollowMode.BetweenT:
					break;
				default:
					throw new ArgumentException("");
			}
		}

		void Update()
		{
			if (Curve.controlPoints.Count > 1)
			{
				if (this.weight > 0.001f)
				{
					ExecutSnapFollowPath();
				}
			}
		}

		private void getClosestControlPoints(Transform target, out ControlPoint a, out ControlPoint b, int segments = 5)
		{

			float closet = float.MaxValue;
			a = null;
			b = null;
			for (int i = 1; i < Curve.controlPoints.Count; i++)
			{
				ControlPoint prev = Curve.controlPoints[i - 1];
				ControlPoint cur = Curve.controlPoints[i];
				/*	*/
				for (int j = 0; j < segments + 1; j++)
				{
					Vector3 segPos = BeizerCurve.GetPosition_(prev, cur, (float)j / (float)segments);
					float dist = Vector3.Distance(target.transform.position, segPos);
					if (dist < closet)
					{
						closet = dist;
						a = prev;
						b = cur;
					}
				}
			}
		}

		private Vector3 getCurrentTangent()
		{
			return BeizerCurve.GetTangent_(a, b, 0.1f);
		}

		private void ExecutSnapFollowPath()
		{


			/*	Determine the object axis.	*/
			Vector3 forward;
			Vector3 up;
			Vector3 right;
			switch (space)
			{
				default:
				case Space.LocalSpace:
					forward = target.rotation * Vector3.forward;
					up = target.rotation * Vector3.up;
					right = target.rotation * Vector3.right;
					break;
				case Space.WorldSpace:
					forward = Vector3.forward;
					up = Vector3.up;
					right = Vector3.right;
					break;
			}


			getCurrentTangent();


			/*	*/
			float _t = (a.position - target.transform.position).magnitude / (a.position - b.position).magnitude;
			if (_t > 1.0f)
				_t = Mathf.Min(1.0f, _t);
			Vector3 pos = BeizerCurve.GetPosition_(a, b, _t);

			/*	Compute the new position.	*/
			if (Lock)
			{
				if (FreezeX)
				{
					right *= 0.0f;
				}
				if (FreezeY)
				{
					up *= 0.0f;
				}
				if (FreezeZ)
				{
					forward *= 0.0f;
				}
			}
			Vector3 _newPos = new Vector3(pos.x * forward.x, pos.y * forward.y, target.transform.position.z);
			this.target.position = Vector3.Lerp(target.transform.position, _newPos, this.weight);
		}

		void OnDrawGizmos()
		{
			if (target)
			{
				//Gizmos.DrawLine(this.target.position, this.target.position + this.curve.getTangent())
			}
		}
	}

}