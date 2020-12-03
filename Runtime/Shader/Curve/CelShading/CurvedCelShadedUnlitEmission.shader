Shader "Curve/CelShaded/Unlit Emission"
{
	Properties
	{
		[Header(Main Color)]
		[MainColor] 
		_Color ("Color", Color) = (1,1,1,1)
		[MainTexture]
		_MainTex ("Texture", 2D) = "white" {}
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)

		[Header(Emission), HDR]
		_Emission ("Emission", Color) = (0, 0, 0)
		[Toggle(_EMISSION_MAP)] _Fancy ("Emission", Float) = 0	
		[HDR,NoScaleOffset] _EmissionMap ("Emission", 2D) = "black" {}

		[Space(5)]

		[Header(Blend State)]
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1 //"One"
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend", Float) = 0 //"Zero"
		[Space(5)]

		//[KeywordEnum(None, Add, Multiply)] _Overlay ("Overlay mode", Float) = 0 - Display a popup with None,Add,Multiply choices. Each option will set _OVERLAY_NONE, _OVERLAY_ADD, _OVERLAY_MULTIPLY shader keywords. 
		[Header(Other)]
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 							//"Back"
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4 					//"LessEqual"
		[Enum(Off,0,On,1)] _ZWrite("ZWrite", Float) = 1.0 											//"On"
		[Enum(UnityEngine.Rendering.ColorWriteMask)] _ColorWriteMask("ColorWriteMask", Float) = 15 	//"All"
	}
	SubShader
	{
		Tags { "RenderType"="Opaque"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 600
		Pass
		{
			Name "META"
			Tags {"LightMode"="Meta"}
			Cull Off
			CGPROGRAM
			
			#include"UnityStandardMeta.cginc"
			
			//			sampler2D _EmissionMap;
			float4 _Emission;
			float4 frag_meta2 (v2f_meta i): SV_Target
			{
				// We're interested in diffuse & specular colors
				// and surface roughness to produce final albedo.
				FragmentCommonData data = UNITY_SETUP_BRDF_INPUT (i.uv);
				UnityMetaInput o;
				UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);
				fixed4 c = tex2D (_MainTex, i.uv);
				o.Albedo = fixed3(c.rgb * _Color.rgb);
				o.Emission = tex2D (_EmissionMap, i.uv) * _Emission;
				return UnityMetaFragment(o);
			}
			
			#pragma vertex vert_meta
			#pragma fragment frag_meta2
			#pragma shader_feature _EMISSION_MAP
			ENDCG
		}

		Pass
		{
			Blend[_SrcBlend][_DstBlend]
			ZTest[_ZTest]
			ZWrite[_ZWrite]
			Cull[_Cull]
			ColorMask[_ColorWriteMask]
			Name "ForwardBase Curved CelShaded Emission"
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			#pragma multi_compile_fwdbase
			#pragma target 3.0

			#pragma shader_feature _EMISSION_MAP
			#pragma multi_compile _ UNITY_HDR_ON
			#pragma multi_compile _ LIGHTPROBE_SH
			#pragma multi_compile _ LIGHTMAP_ON VERTEXLIGHT_ON

			#include "UnityCG.cginc"
			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
			UNITY_INSTANCING_BUFFER_END(Props)

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbientColor;
			float _Glossiness;
			float4 _SpecularColor;
			float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

			/*	*/
			sampler2D _EmissionMap;
			float4 _EmissionTex_ST;
			float4 _Emission;

			#include"../Common/CurvedCelShadedCode.cginc"
			ENDCG
		}

		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
	Fallback "Curve/CelShadedUnlit"
}
