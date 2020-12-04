Shader "Curve/CelShaded/CelShaded"
{
	Properties
	{
		[KeywordEnum(None, TRIANGLE, REGULAR, UNIFORM, CUSTOM)] _Clip ("", Float) = 0
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

		[Header(Emission)]
		[Toggle(_USE_EMISSION_TEX)] _UseEmission ("Emission", Float) = 0	
		[HDR]
		_Emission ("Color", Color) = (0, 0, 0)
		[HDR,NoScaleOffset] _EmissionTex ("Texture", 2D) = "black" {}

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
		UsePass "Outlined/Outline/Outline"

		Pass
		{
			Name "META"
			Tags {"LightMode"="Meta"}
			Cull Off
			Blend[_SrcBlend][_DstBlend]
			ZWrite[_ZWrite]
			ColorMask[_ColorWriteMask]
			CGPROGRAM
			#include"UnityStandardMeta.cginc"
			
			float4 frag_meta2 (v2f_meta i): SV_Target
			{
				// We're interested in diffuse & specular colors
				// and surface roughness to produce final albedo.
				
				FragmentCommonData data = UNITY_SETUP_BRDF_INPUT (i.uv);
				UnityMetaInput o;
				UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);

				fixed4 c = tex2D (_MainTex, i.uv);
				o.Albedo = fixed3(c.rgb * _Color.rgb);
				o.Emission = Emission(i.uv.xy); 

				/*	*/
				//o.SpecularColor = getRimColor(_RimColor, normal, NdotL, viewDir, _RimAmount, _RimThreshold);
				//float4 rim = getRimColor(_RimColor, normal, NdotL, viewDir, _RimAmount, _RimThreshold);
				return UnityMetaFragment(o);
			}
			
			#pragma vertex vert_meta
			#pragma fragment frag_meta2
			#pragma shader_feature _USE_EMISSION_TEX
			ENDCG
		}

		Pass
		{
			Blend[_SrcBlend][_DstBlend]
			ZTest[_ZTest]
			ZWrite[_ZWrite]
			Cull[_Cull]
			ColorMask[_ColorWriteMask]
			Name "ForwardBase Curved CelShaded"
			Tags
			{
				"LightMode" = "ForwardBase"
				"PassFlags" = "OnlyDirectional"
			}
			CGPROGRAM
			/*	*/
			#pragma shader_feature _USE_EMISSION_TEX
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog 
			#pragma multi_compile_instancing addshadow
			#pragma multi_compile_fwdbase
			#pragma target 3.0

			#pragma multi_compile _ UNITY_HDR_ON
			#pragma multi_compile _ LIGHTPROBE_SH
			#pragma multi_compile _ LIGHTMAP_ON VERTEXLIGHT_ON 

			#include "UnityCG.cginc"

			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Emission)
			UNITY_INSTANCING_BUFFER_END(Props)


			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbientColor;
			float _Glossiness;
			float4 _SpecularColor;
			float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

			sampler2D _EmissionTex;
			float4 _EmissionTex_ST;

			//UNITY_SPECCUBE_BOX_PROJECTION
			//UNITY_SPECCUBE_BLENDING
			//UNITY_ENABLE_DETAIL_NORMALMAP
			//UNITY_LIGHT_PROBE_PROXY_VOLUME
			//UNITY_LIGHTMAP_FULL_HDR
			#include"../Common/CurvedCelShadedCode.cginc"

			ENDCG
		}

		// Pass
		// {
		// 	Blend One One
		// 	ZTest[_ZTest]
		// 	ZWrite Off
		// 	Cull[_Cull]
		// 	ColorMask[_ColorWriteMask]
		// 	Name "ForwardAdd Curved CelShaded"
		// 	Tags
		// 	{
		// 		"LightMode" = "ForwardAdd"
		// 		"PassFlags" = "OnlyDirectional"
		// 	}
		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag

		// 	#pragma multi_compile_fog
		// 	#pragma multi_compile_instancing
		// 	#pragma multi_compile_fwdadd
		// 	#pragma target 3.0

		// 	#pragma multi_compile _ UNITY_HDR_ON
		// 	#pragma multi_compile _ LIGHTPROBE_SH
		// 	#pragma multi_compile _ LIGHTMAP_ON VERTEXLIGHT_ON

		// 	#include "UnityCG.cginc"

		// 	UNITY_INSTANCING_BUFFER_START(Props)
		// 	UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
		// 	UNITY_INSTANCING_BUFFER_END(Props)

		// 	sampler2D _MainTex;
		// 	float4 _MainTex_ST;
		// 	float4 _AmbientColor;
		// 	float _Glossiness;
		// 	float4 _SpecularColor;
		// 	float4 _RimColor;
		// 	float _RimAmount;
		// 	float _RimThreshold;

		// 	#include"../Common/CurvedCelShadedCode.cginc"
		// 	ENDCG
		// }

		// shadow caster rendering pass, implemented manually
		UsePass "Curve/VertexLitShadow/ShadowCaster"
		Pass
		{

			Name "DeferredCurvedCelShaded"
			Tags
			{
				"LightMode" = "Deferred"
				"PassFlags" = "OnlyDirectional"
			}
			LOD 600
			
			CGPROGRAM
			#pragma vertex vertex_shader
			#pragma fragment pixel_shader
			#pragma multi_compile_fog
			#pragma multi_compile_instancing

			#pragma exclude_renderers nomrt
			//#pragma multi_compile_lightpass
			#pragma multi_compile ___ UNITY_HDR_ON
			#pragma shader_feature _USE_EMISSION_TEX
			#pragma target 3.0
			
			#include "../Common/CurvedGlobalVariables.cginc"

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			#include "../Common/CurvedFunctions.cginc"
			#include "../Common/CelShade.cginc"

			#include "UnityPBSLighting.cginc"

			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Emission)
			UNITY_INSTANCING_BUFFER_END(Props)
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbientColor;
			float _Glossiness;
			float4 _SpecularColor;
			float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

			sampler2D _EmissionTex;
			float4 _EmissionTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct structureVS 
			{
				float4 screen_vertex : SV_POSITION;
				float4 world_vertex : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float2 uv : TEXCOORD2;
				float3 viewDir : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct structurePS
			{
				half4 albedo : SV_Target0;
				half4 specular : SV_Target1;
				half4 normal : SV_Target2;
				half4 emission : SV_Target3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			structureVS vertex_shader (appdata v) 
			{
				structureVS vs;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, vs);
				vs.uv = TRANSFORM_TEX(v.uv, _MainTex);
				float4 WorldVertex = curveTransformationWorldVertex(v.vertex);
				vs.screen_vertex = UnityObjectToClipPos(WorldVertex);
				//vs.screen_vertex = curvedTransformation(_CurveStrength, _Direction, UnityObjectToClipPos(v.vertex));
				vs.world_vertex = WorldVertex;
				//vs.world_vertex = mul(unity_ObjectToWorld, curvedTransformation(_CurveStrength, _Direction, v.vertex));				
				vs.normal = curveNormal(_CurveStrength, _Direction,  0, UnityObjectToWorldNormal(v.normal));
				vs.viewDir = WorldSpaceViewDir(v.vertex);
				return vs;
			}
			
			structurePS pixel_shader (structureVS vs) : SV_Target
			{
				structurePS ps;
				UNITY_SETUP_INSTANCE_ID(vs);

				/*	*/
				float3 normal = normalize(vs.normal);
				
				/*	*/
				float NdotL = dot(_WorldSpaceLightPos0, normal);
				float lightIntensity = smoothstep(0, 0.01, NdotL);
				/*	*/
				float3 viewDir = normalize(vs.viewDir);

				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
				float NdotH = dot(normal, halfVector);

				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
				float4 specular = specularIntensitySmooth * _SpecularColor;

				float4 rim = getRimColor(_RimColor, normal, NdotL, viewDir, _RimAmount, _RimThreshold);

				ps.albedo = tex2D(_MainTex, vs.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);

				ps.specular = float4((_SpecularColor + rim).xyz, specularIntensity);
				ps.normal = half4( normal * 0.5 + 0.5, 1.0 );
				#if defined(_USE_EMISSION_TEX)
					ps.emission = tex2D(_EmissionTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Emission)
				#else
					ps.emission = half4(0,0,0,1);
				#endif
				#ifndef UNITY_HDR_ON
					ps.emission.rgb = exp2(-ps.emission.rgb);
				#endif
				return ps;
			}

			ENDCG
		}

	}
	Fallback "Curve/CelShadedUnlit"
}
