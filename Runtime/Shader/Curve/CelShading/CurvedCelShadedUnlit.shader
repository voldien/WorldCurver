Shader "Curve/CelShaded/Unlit"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1


        [Header(Blend State)]
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1 //"One"
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend", Float) = 0 //"Zero"
        [Space(5)]

		[Header(Outline)]
		[Toggle(_OUTLINE_ON)] 
		_UseOutline ("Outline", Float) = 0
		[KeywordEnum(None, TRIANGLE, REGULAR, UNIFORM, CUSTOM)] _Outline ("Outline mode", Float) = 0
		_OutlineColor ("Outline color", Color) = (0,0,0,1)
		_OutlineWidth ("Outlines width", Range (0.0, 2.0)) = 1.1

        [Header(Other)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 							//"Back"
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4 					//"LessEqual"
        [Enum(Off,0,On,1)] _ZWrite("ZWrite", Float) = 1.0 											//"On"
        [Enum(UnityEngine.Rendering.ColorWriteMask)] _ColorWriteMask("ColorWriteMask", Float) = 15 	//"All"
	}
	SubShader
	{
		Tags { "RenderType"="Opaque"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200
		UsePass "Outlined/Outline/Outline"
		Pass
		{
			Blend[_SrcBlend][_DstBlend]
			ZTest[_ZTest]
			ZWrite[_ZWrite]
			Cull[_Cull]
			ColorMask[_ColorWriteMask]
			Name "Forward Curved Unlit CelShaded"
			Tags
			{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma noshadow novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd nolppv noshadowmask
			#pragma multi_compile_instancing 

			#include "Lighting.cginc"
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

			#include "../Common/CurvedFunctions.cginc"
			#include "../Common/CurvedGlobalVariables.cginc"
			#include "../Common/CurvedCelShadedCode.cginc"
			ENDCG
		}
	}
}
