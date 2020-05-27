#include "UnityCG.cginc"
#include "CurvedFunctions.cginc"
#include "CurvedGlobalVariables.cginc"

//TODO rename
UNITY_INSTANCING_BUFFER_START(Props)
UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
UNITY_INSTANCING_BUFFER_END(Props)

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float4 color : COLOR;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
	float2 uv : TEXCOORD0;
	UNITY_FOG_COORDS(1)
	float4 color : TEXCOORD2;
	float4 vertex : SV_POSITION;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

sampler2D _MainTex;
float4 _MainTex_ST;


v2f vert(appdata v)
{
	v2f o;

	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_TRANSFER_INSTANCE_ID(v, o);
	/*	*/
	o.vertex = curveTransformationClipSpace(v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.color = v.color;
	UNITY_TRANSFER_FOG(o, o.vertex);
	return o;
}

fixed4 frag(v2f i) : SV_Target
{
	UNITY_SETUP_INSTANCE_ID(i);

	/*	*/
	fixed4 col = tex2D(_MainTex, i.uv) * i.color * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
	/*	*/
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
}