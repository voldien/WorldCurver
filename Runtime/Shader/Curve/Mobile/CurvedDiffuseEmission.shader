Shader "Curve/Mobile/Diffuse Emission"
{
    Properties
    {
		[HDR]
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[HDR]
		_AmbientColor ("AmbientColor", Color) = (0.2,0.2,0.2,1.0)
		[HDR]
		_EmissionColor ("EmissionColor", Color) = (1,1,1,1)
		_EmissionTex ("Emission (RGB)", 2D) = "white" {}
    }
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200

		Pass
		{
			Name "Forward"
			Tags
			{
				"LightMode" = "ForwardBase"
				//"PassFlags" = "OnlyDirectional"
			}
			CGPROGRAM

			#pragma vertex diffuse_vert
			#pragma fragment diffuse_frag
			#pragma multi_compile_fog multi_compile_instancing
			#pragma instancing_options assumeuniformscaling

			#pragma exclude_renderers nomrt
			#pragma multi_compile_lightpass
			#pragma multi_compile ___ UNITY_HDR_ON
			#pragma target 2.0
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbientColor;

			sampler2D _EmissionTex;
			float4 _EmissionTex_ST;
			float4 _EmissionColor;

			#define CURVE_EMISSION
			#include "../Common/CurvedMobileCode.cginc"

			ENDCG
		}
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
}
