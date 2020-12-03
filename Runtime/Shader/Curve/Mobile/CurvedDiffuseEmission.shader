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
			Name "META"
			Tags {"LightMode"="Meta"}
			Cull Off
			CGPROGRAM
			
			#include"UnityStandardMeta.cginc"
			
			//            sampler2D _MainTex;
			//            fixed4 _Color;
			sampler2D _EmissionTex;
			//			fixed4 _EmissionColor;
			float4 frag_meta2 (v2f_meta i): SV_Target
			{
				// We're interested in diffuse & specular colors
				// and surface roughness to produce final albedo.
				
				FragmentCommonData data = UNITY_SETUP_BRDF_INPUT (i.uv);
				UnityMetaInput o;
				UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
				fixed4 c = tex2D (_MainTex, i.uv);
				o.Albedo = fixed3(c.rgb * _Color.rgb);
				o.Emission = tex2D (_EmissionTex, i.uv) * _EmissionColor;
				return UnityMetaFragment(o);
			}
			
			#pragma vertex vert_meta
			#pragma fragment frag_meta2
			#pragma shader_feature _EMISSION
			ENDCG
		}


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

			#pragma shader_feature _EMISSION_MAP

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
