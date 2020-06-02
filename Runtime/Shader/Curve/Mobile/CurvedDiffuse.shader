Shader "Curve/Mobile/Diffuse"
{
    Properties
    {

		[HDR]
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		[HDR]
		_AmbientColor ("AmbientColor", Color) = (0.2,0.2,0.2,1.0)
    }
	SubShader
	{
		Tags { "RenderType"="Opqaue" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200

		Pass
		{
			Name "Curved Mobile Diffuse"
			Tags
			{
				"LightMode" = "ForwardBase"
				//"LightMode" = "ForwardAdd"
				"PassFlags" = "OnlyDirectional"
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
			
			#include "../Common/CurvedMobileCode.cginc"
			ENDCG
		}
		
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
	SubShader{
		Tags { "RenderType"="Opqaue" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200

		Pass
		{
			Name "Curved Mobile Diffuse"
			Tags
			{
				"LightMode" = "Vertex"
				"PassFlags" = "OnlyDirectional"
			}
			CGPROGRAM
			#pragma vertex diffuse_vert
			#pragma fragment diffuse_frag
			#pragma multi_compile_fog multi_compile_instancing noambient noforwardadd
			#pragma instancing_options assumeuniformscaling

			#pragma exclude_renderers nomrt
			#pragma multi_compile_lightpass
			#pragma multi_compile ___ UNITY_HDR_ON
			#pragma target 2.0

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbientColor;
			
			#include "../Common/CurvedMobileCode.cginc"

		// 			i.vertexLightColor = Shade4PointLights(
		// 	unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
		// 	unity_LightColor[0].rgb, unity_LightColor[1].rgb,
		// 	unity_LightColor[2].rgb, unity_LightColor[3].rgb,
		// 	unity_4LightAtten0, i.worldPos, i.normal
		// );

			ENDCG
		}
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
}
