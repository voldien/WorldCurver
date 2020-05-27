Shader "Curve/Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
	SubShader
	{
		Name "Standard"
		Tags { "RenderType"="Opaque" "CanUseSpriteAtlas"="True" "DisableBatching"="False" }
		LOD 600
		ZWrite On ZTest LEqual Cull Off
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0
		#pragma vertex vert
		#pragma instancing_options assumeuniformscaling
		#pragma multi_compile_instancing
		#include "UnityCG.cginc"
		#include "../Common/CurvedGlobalVariables.cginc"
		#include "../Common/CurvedFunctions.cginc"

		sampler2D _MainTex;
		
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

		half _Glossiness;
		half _Metallic;

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
