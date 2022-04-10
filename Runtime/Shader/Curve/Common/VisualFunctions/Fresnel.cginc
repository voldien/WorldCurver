#ifndef _FRESNEL_H_
#define _FRESNEL_H_
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//TODO rename file.

#include "UnityCG.cginc"
fixed PI = 3.1415;

float fresnel(float3 tagnent : TANGENT, float3 normal : NORMAL, float IOR) {
    return max(pow(dot(tagnent, normal), IOR), 0);
}

float DistributionGGX(float3 N, float3 H, float a)
{
    float a2     = a*a;
    float NdotH  = max(dot(N, H), 0.0);
    float NdotH2 = NdotH*NdotH;
    
    float nom    = a2;
    float denom  = (NdotH2 * (a2 - 1.0) + 1.0);
    denom        = PI * denom * denom;
    
    return nom / denom;
}

float GeometrySchlickGGX(float NdotV, float k)
{
    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    
    return nom / denom;
}

float GeometrySmith(float3 N, float3 V, float3 L, float k)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx1 = GeometrySchlickGGX(NdotV, k);
    float ggx2 = GeometrySchlickGGX(NdotL, k);
    
    return ggx1 * ggx2;
}

float3 fresnelSchlick(float cosTheta, float3 F0)
{
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

float fres() {
    // float3 posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
    // float3 normWorld = normalize(mul(float3x3(unity_ObjectToWorld), v.normal));
    // float3 I = normalize(posWorld - _WorldSpaceCameraPos.xyz);
    // o.R = _Bias + _Scale * pow(1.0 + dot(I, normWorld), _Power);	
}

#endif