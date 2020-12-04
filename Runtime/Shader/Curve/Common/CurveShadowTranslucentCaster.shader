Shader "Curve/VertexLitShadowTranslucent"
{	
	SubShader
	{
		Tags{ "Queue" = "Transparent"}
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
			UNITY_INSTANCING_BUFFER_END(Props)

			struct v2f { 
				V2F_SHADOW_CASTER;
				float2 uv : TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				float4 ObjectCVertex = curveTransformationWorldVertex(v.vertex);
				o.pos = UnityObjectToClipPos(ObjectCVertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				// fixed4 col = tex2D(_MainTex, i.uv) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color)
				// #ifdef UNITY_UI_ALPHACLIP
				// clip (color.a - 0.001);
				// #endif
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
	Fallback Off
}