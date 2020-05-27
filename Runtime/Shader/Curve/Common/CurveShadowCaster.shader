// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			#include "CurvedFunctions.cginc"

            struct v2f { 
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
//				o.vec = mul( unity_ObjectToWorld, v.vertex ).xyz - _LightPositionRange.xyz;
//				o.vec = curvedTransformation(_CurveStrength, _Direction, o.vec).xyz;

                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                //curveTransformation(v.vertex);
                float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
				o.pos = UnityObjectToClipPos(ObjectCVertex);
				//o.pos = curvedTransformation(_CurveStrength, _Direction, o.pos);
//				o.pos = curvedTransformation(_CurveStrength, _Direction, o.pos);
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