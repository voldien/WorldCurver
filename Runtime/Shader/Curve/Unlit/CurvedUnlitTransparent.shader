Shader "Curve/UnlitTransparent"
{ 
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" }
		LOD 200

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog multi_compile_instancing noambient noforwardadd

			#include "../Common/CurvedCode.cginc"

			ENDCG
		}
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}
}