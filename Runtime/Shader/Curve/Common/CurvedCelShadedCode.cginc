#ifndef _CURVED_CELSHADED_CODE_GCINC_
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members diff)
#define _CURVED_CELSHADED_CODE_GCINC_ 1

#pragma exclude_renderers d3d11
#include "CurvedGlobalVariables.cginc"

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

#include "UnityStandardUtils.cginc"

#include "CurvedFunctions.cginc"
#include "CelShade.cginc"

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : NORMAL;
	#if defined(LIGHTMAP_ON)
		float2 uv1 : TEXCOORD1;
	#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
	float4 pos : SV_POSITION;
	float3 worldNormal : NORMAL;
	float2 uv : TEXCOORD0;
	float3 viewDir : TEXCOORD1;
	#if defined(LIGHTMAP_ON)
		float2 uv1 : TEXCOORD4;
	#endif
	#if defined(VERTEXLIGHT_ON)
		half4 vertexLightColor : COLOR;
	#endif
	#if defined(UNITY_LIGHT_PROBE_PROXY_VOLUME)
		float3 worldPos : TEXCOORD5;
	#endif
	#if defined(LIGHTPROBE_SH)
	float4 ambient : COLOR1;
	#endif
	UNITY_FOG_COORDS(3)
	SHADOW_COORDS(2)
	//#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

v2f vert (appdata v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_TRANSFER_INSTANCE_ID(v, o);
	#if defined(VERTEXLIGHT_ON)
		
	#endif

	float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
	/*	Compute world vertex coordiante for light probs.	*/
	#if defined(UNITY_LIGHT_PROBE_PROXY_VOLUME)
		o.worldPos = mul(unity_ObjectToWorld, v.vertex);
	#endif
	/*	*/
	o.pos = UnityObjectToClipPos(ObjectCVertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.worldNormal = UnityObjectToWorldNormal(v.normal);//TODO change to the curve version later.
	o.viewDir = WorldSpaceViewDir(ObjectCVertex);

	/*	Compute the lightmap coordinate.	*/
	#if defined(LIGHTMAP_ON)
		o.uv1 = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#endif

	#if defined(VERTEXLIGHT_ON)
		o.vertexLightColor = float4(ShadeVertexLights(o.pos, o.worldNormal), 1.0);
	#endif
	
	#if defined(LIGHTPROBE_SH)
	o.ambient = float4(ShadeSH9(float4(o.worldNormal, 1)), 1);
	#endif

	TRANSFER_SHADOW(o);
	UNITY_TRANSFER_FOG(o,o.pos);
	return o;
}

half4 GetAmbient(v2f i){
	#if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED)
		#if defined(UNITY_LIGHT_PROBE_PROXY_VOLUME)
			return half4(ShadeSHPerPixel(i.worldNormal, _AmbientColor, i.worldPos), 1.0);
		#elif defined(LIGHTPROBE_SH)
			return i.ambient;
		#else
			return _AmbientColor;
		#endif
	#else
		return 0;
	#endif
}

half4 GetEmission (v2f i) {
	#if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED)
		#if defined(_EMISSION_MAP)
			return tex2D(_EmissionTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Emission)
		#else
			return 0;
		#endif
	#else
		return 0;
	#endif
}

float4 ComputeLight(v2f i){
	#ifdef UNITY_PASS_FORWARDADD
		#if defined(POINT)
		return float4(Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb,
			unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, i.pos, i.worldNormal), 1.0);
		#else
			return 0;
		#endif
	#else
		return 0;
	#endif
}

float4 ComputeLightMap(v2f i){
	#if defined(UNITY_PASS_FORWARDBASE)
		#if defined(LIGHTMAP_ON)
			#if defined(SHADOWS_SHADOWMASK)
			#endif
			fixed4 lightdata = fixed4(DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv1)), 1.0);
			fixed4 totalLightAcc = lightdata;
			return totalLightAcc;
			#if defined(DIRLIGHTMAP_COMBINED)
			return 0;
			#endif
		#else
			return 0;
		#endif
	#else
	fixed lightdata = 0 ;
	fixed4 totalLightAcc = 0;
	return totalLightAcc;
	#endif
}

half4 ComputeDirectionLight(v2f i) {
	#if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED)
		#if defined(DIRECTIONAL) || defined(DIRECTIONAL_COOKIE)
		/*	Compute directional light.	*/
		float3 normal = normalize(i.worldNormal);//half3(i.worldNormal, 1);
		//float NdotL = dot(_WorldSpaceLightPos0, normal);
		float NdotL = max(dot(_WorldSpaceLightPos0, normal), 0);
		float shadow = SHADOW_ATTENUATION(i);
		float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
		return lightIntensity * _LightColor0;
		#else
			return 0;
		#endif
	#else
		return 0;
	#endif
}



fixed4 frag (v2f i) : SV_Target
{
	UNITY_SETUP_INSTANCE_ID(i);

	/*	*/
	half4 ambient = GetAmbient(i);
	fixed4 totalLightAcc = ComputeDirectionLight(i) + ComputeLightMap(i) + ComputeLight(i);
	#if defined(VERTEXLIGHT_ON)
		totalLightAcc += i.vertexLightColor;
	#endif
	totalLightAcc.a = 1;

	#if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED)

	/*	Directional Light*/
	#if defined(DIRECTIONAL)
	float3 normal = normalize(i.worldNormal);
	float NdotL = dot(_WorldSpaceLightPos0, normal);

	/*	Compute directional light.	*/
	float3 viewDir = normalize(i.viewDir);
	float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
	float NdotH = dot(normal, halfVector);

	/*	Compute specular.	*/
	float shadow = SHADOW_ATTENUATION(i);
	float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);

	//float TotalLightIntensity = length(totalLightAcc) * 0.29;
	float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
	half specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
	float4 specular = specularIntensitySmooth * _SpecularColor;

	/*	Compute rim light.	*/	
	float4 rim = getRimColor(_RimColor, normal, NdotL, viewDir, _RimAmount, _RimThreshold);
	#else
		half4 rim = 0;
		half4 specular = 0;	
	#endif
	#else
		half4 rim = 0;
		half4 specular = 0;
	#endif
	
	/*	*/
#ifdef _USE_EMISSION_TEX
	#ifdef UNITY_HDR_ON
	
	#endif
	
	fixed emission = GetEmission(i);
	fixed4 col = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color) * ( ambient + totalLightAcc + specular + rim + emission);
#else
	fixed4 col = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color) * ( ambient + totalLightAcc + specular + rim);

	//clip(col.a - _Cutout);
#endif
	
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
}

#endif
// // sample the texture
// #if defined(UNITY_HDR_ON)

// #endif