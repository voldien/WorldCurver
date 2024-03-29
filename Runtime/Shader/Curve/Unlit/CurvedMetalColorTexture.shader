Shader "Curve/UnlitMetalTexture"
{ 
	Properties
	{
        _Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "IgnoreProjector" = "True"  "DisableBatching"="False" "CanUseSpriteAtlas"="True" "DisableBatching"="False"}
		LOD 200

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fog multi_compile_instancing noambient noforwardadd
			#pragma instancing_options assumeuniformscaling
				
			#include "../Common/CurvedCode.cginc"
			#include "../Common/VisualFunctions/Fresnel.cginc"

			ENDCG
		}
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}

}