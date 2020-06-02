#ifndef _CURVED_MOBILE_CODE_CGINC_
#define _CURVED_MOBILE_CODE_CGINC_


#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#include "CurvedFunctions.cginc"
#include "CurvedGlobalVariables.cginc"

//TODO rename
UNITY_INSTANCING_BUFFER_START(Props)
UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
UNITY_INSTANCING_BUFFER_END(Props)

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : NORMAL;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
	float4 pos : SV_POSITION;
	float3 worldNormal : NORMAL;
	float2 uv : TEXCOORD0;
	UNITY_FOG_COORDS(2)
	SHADOW_COORDS(1)
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

v2f diffuse_vert(appdata v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_TRANSFER_INSTANCE_ID(v, o);

	float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
	o.pos = UnityObjectToClipPos(ObjectCVertex);

	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.worldNormal = UnityObjectToWorldNormal(v.normal);

	TRANSFER_SHADOW(o);
	UNITY_TRANSFER_FOG(o,o.pos);
	return o;
}

fixed4 diffuse_frag(v2f i) : SV_Target
{
	UNITY_SETUP_INSTANCE_ID(i);

	/*	*/
	float3 normal = normalize(i.worldNormal);
	
	/*	*/

	float4 lightColor = float4(0,0,0,1);
	#ifdef UNITY_PASS_FORWARDBASE
		float NdotL = dot(_WorldSpaceLightPos0, normal);
		float shadow = SHADOW_ATTENUATION(i);
		float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
		lightColor = _LightColor0 * lightIntensity;
	#endif

	#ifdef UNITY_PASS_DEFERRED
	
	#endif

	#ifdef UNITY_PASS_FORWARDADD
		lightColor += float4(Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb,
			unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, i.pos, i.worldNormal), 1.0);
		return lightColor;
	#endif


#ifdef CURVE_EMISSION
	#ifdef UNITY_HDR_ON
	
	#endif
	fixed emission = tex2D(_EmissionTex, i.uv);
	fixed4 col = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color) * (unity_AmbientSky +  unity_IndirectSpecColor + lightColor) + emission * _EmissionColor;
#else
	fixed4 col = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color) * (unity_AmbientSky + unity_IndirectSpecColor + lightColor);
#endif 
	
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
}

#endif

//ShadeVertexLights