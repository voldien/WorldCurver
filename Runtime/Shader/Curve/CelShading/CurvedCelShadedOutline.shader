Shader "Curve/CelShadedOutline"
{
	Properties
	{
		[Header(Main Color)]
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
		[HDR]
		_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		_Glossiness("Glossiness", Float) = 32
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (.001, 5.0)) = .5

        [Header(Blend State)]
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Float) = 1 //"One"
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DestBlend", Float) = 0 //"Zero"
        [Space(5)]

        [Header(Other)]
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2 							//"Back"
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4 					//"LessEqual"
        [Enum(Off,0,On,1)] _ZWrite("ZWrite", Float) = 1.0 											//"On"
        [Enum(UnityEngine.Rendering.ColorWriteMask)] _ColorWriteMask("ColorWriteMask", Float) = 15 	//"All"
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Opaque" "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 600
		
		UsePass "Curve/CelShaded/META"
		UsePass "Curve/CelShaded/ForwardBase Curved CelShaded"
		Pass{
			Name "ForwardCurvedCelShadedOutline"
			Cull Front
			ZWrite On
			ColorMask RGB
			//Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _Outline)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _OutlineColor)
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
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			v2f vert (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 offset = TransformViewToProjection(norm.xy);
				
				o.pos.xy += offset * o.pos.z * UNITY_ACCESS_INSTANCED_PROP(Props, _Outline);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				return UNITY_ACCESS_INSTANCED_PROP(Props, _OutlineColor);
			}
			ENDCG

		}

		UsePass "Curve/CelShaded/DeferredCurvedCelShaded"
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
	Fallback Off
}	