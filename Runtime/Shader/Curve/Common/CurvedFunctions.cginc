#ifndef _CURVED_FUNCTIONS_
#define _CURVED_FUNCTIONS_ 1
#include"CurvedGlobalVariables.cginc"

float fadeDistanceFactor(float distance){
	half diffDistance = (distance - _Horizon * 10);
	half diffNorm = max(0, diffDistance);
	distance = diffNorm; //smoothstep(_Horizon, max(diffNorm - diffDistance, _FadeDist), , max(diffNorm - _FadeDist, 1));
	/*	*/
	half t = clamp(diffDistance / _FadeDist, 0, 1);
	float _smooth_distance =  smoothstep(max(diffDistance - _FadeDist, 0), max(diffDistance + _FadeDist, 0),t ) + max(diffDistance - _FadeDist, 0);
	return _smooth_distance;
}

float4 curvedClipSpaceTransformation(float curveStrength, float4 direction, float4 vertex : SV_POSITION) {
	float dist = UNITY_Z_0_FAR_FROM_CLIPSPACE(vertex.z);
	vertex =  vertex - (curveStrength * dist * dist * _ProjectionParams.x * direction);
	return mul(unity_WorldToObject, vertex); 
}

float4 curvedClipSpaceFadeTransformation(float curveStrength, float4 direction, float4 vertex: SV_POSITION) {
	float dist = UNITY_Z_0_FAR_FROM_CLIPSPACE(vertex.z);
	float smooth_distance = fadeDistanceFactor(dist);
	vertex =  vertex - (curveStrength * dist * dist * _ProjectionParams.x * direction);
	return mul(unity_WorldToObject, vertex); 
}

float getVertexDistance(float4 objectVertex){
	half4 wpToCam = (_WorldSpaceCameraPos.xyzx - objectVertex.xyzx) * _LengthInfluence;
	return dot(wpToCam, wpToCam);
}

float4 curveViewSpaceTransformation(float curveStrength, float4 direction,float4 worldPosition){
	half2 wpToCam = _WorldSpaceCameraPos.xz - worldPosition.xz; 

	half distance = getVertexDistance(worldPosition);

	float4 translatedVertex = worldPosition + (distance * curveStrength * direction); 
	return mul(unity_WorldToObject, translatedVertex); 
}

float4 curveWorldSpaceTransformation(float curveStrength, float4 direction, float4 worldPosition){
	half2 wpToCam = _WorldSpaceCameraPos.xz - worldPosition.xz;
	/*	*/
	half distance = getVertexDistance(worldPosition);
	/*	*/
	float4 translatedVertex = worldPosition + (distance * curveStrength * direction); 
	/*	*/
	return mul(unity_WorldToObject, translatedVertex); 
}




float4 curveWorldSpaceFadeTransformation(float curveStrength, float4 direction, float4 worldPosition){
	/*	*/
	half2 wpToCam = _WorldSpaceCameraPos.xz - worldPosition.xz; 

	/*	*/
	half distance = dot(wpToCam, wpToCam);
	float _smooth_distance = fadeDistanceFactor(distance);

	float4 translatedVertex = worldPosition + (_smooth_distance * curveStrength * direction); 

	return mul(unity_WorldToObject, translatedVertex);
}

/*	*/
float curvedClipDistance(float4 vertex : SV_POSITION){
	return UNITY_Z_0_FAR_FROM_CLIPSPACE(vertex.z);
}

/*	*/
float curvedDistance(float vertex : SV_POSITION){
	return length(vertex);
}

/**
*	Compute normal rotation.
*/
float3 curveNormal(float curveStrength, float4 direction, float distance, float3 normal : SV_POSITION){
	float angleY = radians(curveStrength);
	float c = cos(angleY);
	float s = sin(angleY);
	float4x4 rotateXMatrix	= float4x4(	1,	0,	0,	0,
	0,	c,	-s,	0,
	0,	s,	c,	0,
	0,	0,	0,	1);
	return mul(rotateXMatrix, float4(normal, 0)).xyz;
}


float4 curveWorldVertexTransformationWorldVertex(float4 WorldVertex){
	switch(_CurveMode){
		default:
		case CURVE_CLIP_SPACE:
		return curvedClipSpaceTransformation(_CurveStrength, _Direction, UnityObjectToClipPos(WorldVertex));
		case CURVE_WORLD_SPACE:
		return curveWorldSpaceTransformation(_CurveStrength, _Direction, mul(unity_ObjectToWorld, WorldVertex));
		case CURVE_VIEW_SPACE:
		return curveViewSpaceTransformation(_CurveStrength, _Direction,  mul(unity_ObjectToWorld, WorldVertex));
	}
}

float4 curveTransformationWorldVertex(float4 objectVertex){
	switch(_CurveMode){
		default:
		case CURVE_CLIP_SPACE:
		return curvedClipSpaceTransformation(_CurveStrength, _Direction, UnityObjectToClipPos(objectVertex));
		case CURVE_WORLD_SPACE:
		return curveWorldSpaceTransformation(_CurveStrength, _Direction, mul(unity_ObjectToWorld, objectVertex));
		case CURVE_VIEW_SPACE:
		return curveViewSpaceTransformation(_CurveStrength, _Direction,  mul(unity_ObjectToWorld, objectVertex));
	}
}

float4 curveTransformationClipSpace(float4 objectVertex){
	switch(_CurveMode){
		default:
		case CURVE_CLIP_SPACE:
		return UnityObjectToClipPos(curvedClipSpaceTransformation(_CurveStrength, _Direction, UnityObjectToClipPos(mul(unity_ObjectToWorld, objectVertex))));
		case CURVE_WORLD_SPACE:
		return UnityObjectToClipPos(curveWorldSpaceTransformation(_CurveStrength, _Direction, mul(unity_ObjectToWorld, objectVertex)));
		case CURVE_VIEW_SPACE:
		return UnityObjectToClipPos(curveViewSpaceTransformation(_CurveStrength, _Direction,  mul(unity_ObjectToWorld, objectVertex)));
	}
}

#endif