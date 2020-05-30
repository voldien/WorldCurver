Shader "Curve/Unlit Transparent Cutout"
{ 
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Cutout ("Cutout", float) = 0.5
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("__src", Float) = 1.0
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("__dst", Float) = 8.0
		//[Toggle] _ZWrite ("__zw", Float) = 1.0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200

		Pass
		{
			Blend [_SrcBlend] [_DstBlend]
			ZWrite Off
			AlphaToMask On
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog multi_compile_instancing noambient noforwardadd
			#pragma instancing_options assumeuniformscaling
			#define WORLD_CURVE_ALPHA_CLIP
			float _Cutout;		
			#include "../Common/CurvedCode.cginc"

			ENDCG
		}
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
}