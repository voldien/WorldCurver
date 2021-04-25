Shader "Curve/Standard"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
        _GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
        [Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0

        _BumpScale("Scale", Float) = 1.0
        [Normal] _BumpMap("Normal Map", 2D) = "bump" {}

        _Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
        _ParallaxMap ("Height Map", 2D) = "black" {}

        _OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}

        _EmissionColor("Color", Color) = (0,0,0)
        _EmissionMap("Emission", 2D) = "white" {}

        _DetailMask("Detail Mask", 2D) = "white" {}

        _DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
        _DetailNormalMapScale("Scale", Float) = 1.0
        [Normal] _DetailNormalMap("Normal Map", 2D) = "bump" {}

        [Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0


        // Blending state
        [HideInInspector] _Mode ("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
        [HideInInspector] _DstBlend ("__dst", Float) = 0.0
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
    }

    CGINCLUDE
        #define UNITY_SETUP_BRDF_INPUT MetallicSetup
    ENDCG

	SubShader
	{
		Name "FORWARD"
        Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
        LOD 300


		ZWrite On ZTest LEqual
		Cull Back

		Blend [_SrcBlend] [_DstBlend]
		ZWrite [_ZWrite]

		CGPROGRAM
		#pragma target 3.0

		#pragma surface surf Standard fullforwardshadows
		#pragma vertex vert
		#pragma instancing_options assumeuniformscaling

		// -------------------------------------

		#pragma shader_feature_local _NORMALMAP
		#pragma shader_feature_local _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
		#pragma shader_feature _EMISSION
		#pragma shader_feature_local _METALLICGLOSSMAP
		#pragma shader_feature_local _DETAIL_MULX2
		#pragma shader_feature_local _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
		#pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature_local _GLOSSYREFLECTIONS_OFF
		#pragma shader_feature_local _PARALLAXMAP

		#include "UnityCG.cginc"
		#include "../Common/CurvedGlobalVariables.cginc"
		#include "../Common/CurvedFunctions.cginc"

		half        _Cutoff;

		sampler2D   _MainTex;
		//float4      _MainTex_ST;

		sampler2D   _DetailAlbedoMap;
		float4      _DetailAlbedoMap_ST;

		sampler2D   _BumpMap;
		half        _BumpScale;

		sampler2D   _DetailMask;
		sampler2D   _DetailNormalMap;
		half        _DetailNormalMapScale;

		sampler2D   _SpecGlossMap;
		sampler2D   _MetallicGlossMap;
		half        _Metallic;
		float       _Glossiness;
		float       _GlossMapScale;

		sampler2D   _OcclusionMap;
		half        _OcclusionStrength;

		sampler2D   _ParallaxMap;
		half        _Parallax;
		half        _UVSec;

		half4       _EmissionColor;
		sampler2D   _EmissionMap;
		
		struct Input
		{
			float2 uv_MainTex;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		struct appdata
		{
			float4 vertex    : POSITION;  // The vertex position in model space.
			float3 normal    : NORMAL;    // The vertex normal in model space.
			float4 texcoord  : TEXCOORD0; // The first UV coordinate.
			float4 texcoord1 : TEXCOORD1; // The second UV coordinate.
			float4 texcoord2 : TEXCOORD2; // The second UV coordinate.
			float4 tangent   : TANGENT;   // The tangent vector in Model Space (used for normal mapping).
			float4 color     : COLOR;     // Per-vertex color
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			o.Emission = _EmissionColor * tex2D (_EmissionMap, IN.uv_MainTex).rgb;
			o.Occlusion = tex2D(_OcclusionMap, IN.uv_MainTex).r;
			o.Normal = tex2D(_BumpMap,IN.uv_MainTex);
		}

		void vert (inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_TRANSFER_INSTANCE_ID(v, o);
			float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
			v.vertex = ObjectCVertex;
			v.normal = UnityObjectToWorldNormal(v.normal);
			UNITY_TRANSFER_DEPTH(v);
		}
		ENDCG
	}
	FallBack "Curve/UnlitTexture"
}
