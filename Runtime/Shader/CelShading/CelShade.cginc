#ifndef _CEL_SHADE_FUNCTIONS_
#define _CEL_SHADE_FUNCTIONS_ 1

#pragma multi_compile ___ PRECOMPUTE_GLOSSY

float getRimAmmount(float3 normal: NORMAL, float NdotL, float3 viewDir, float RimAmount, float RimThreshold){
	float4 rimDot = 1 - dot(viewDir, normal);
	float rimIntensity = rimDot * pow(NdotL, RimThreshold);
	return smoothstep(RimAmount - 0.01, RimAmount + 0.01, rimIntensity);
}

float getRimColor(float4 RimColor, float3 normal: NORMAL , float NdotL, float3 viewDir, float RimAmount, float RimThreshold){
	return getRimAmmount(normal, NdotL, viewDir, RimAmount, RimThreshold) * RimColor;
}

float ComputeDirectionLight(float3 normal: NORMAL, float shadow){
	#if defined(UNITY_PASS_FORWARDBASE) || defined(UNITY_PASS_DEFERRED)
		#if defined(DIRECTIONAL) || defined(DIRECTIONAL_COOKIE)
			float NdotL = dot(_WorldSpaceLightPos0, normal);
			float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
			return lightIntensity;
		#else
			return 0;
		#endif
	#else
		return 0;
	#endif
}

#endif