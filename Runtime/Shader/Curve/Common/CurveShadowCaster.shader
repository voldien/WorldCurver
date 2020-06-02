Shader "Curve/VertexLitShadow"
{	
	SubShader
	{
		Tags{ "Queue" = "Geometry"}
		Pass
		{
			Name"ShadowCaster"
			Tags {"LightMode"="ShadowCaster"}
			ZWrite On ZTest LEqual Cull Off
			Offset 0, 0
			ColorMask 0
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "CurvedFunctions.cginc"

			struct v2f { 
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
				o.pos = UnityObjectToClipPos(ObjectCVertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
	Fallback Off
}