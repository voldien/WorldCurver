using UnityEngine;
namespace Curves
{
	public class SimpleFollowPath : MonoBehaviour
	{

		public Transform target;
		public BeizerCurve curve;
		private void Update()
		{

			Vector3 f = target.rotation * Vector3.forward;
			/*	*/
			Vector3 pos = curve.GetPosition(0, 0.0f);


		}
	}
}