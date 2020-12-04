Shader "Outlined/Outline" {
	Properties {
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_Outline ("Outline width", Range (0, 1)) = .1
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" }

		Pass //Outline
		{
			Name "Outline"
			ZWrite On
			Cull Front
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature _OUTLINE_CUSTOM _OUTLINE_UNIFORM _OUTLINE_REGULAR _OUTLINE_TRIANGLE

			float _OutlineWidth;
			float _Outline;
			float4 _OutlineColor;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : POSITION;
			};
			

			v2f vert(appdata v)
			{
				#if _OUTLINE_TRIANGLE
					appdata original = v;
					v.vertex.xyzw += _OutlineWidth * normalize(v.vertex.xyzw);
					v.vertex.x -= _OutlineWidth/4;
					v.vertex.y += _OutlineWidth/4;

					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				#elif defined(_OUTLINE_REGULAR)
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
				
					float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
					float2 offset = mul((float2x2)UNITY_MATRIX_P, norm.xy);
				
					o.pos.xy += offset * o.pos.z * _OutlineWidth;
					return o;
				#elif defined(_OUTLINE_UNIFORM)
					appdata original = v;
					v.vertex.xyz += _OutlineWidth * normalize(v.vertex.xyz);

					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				#elif defined(_OUTLINE_CUSTOM)
					// just make a copy of incoming vertex data but scaled according to normal direction
					v2f o;

					//Camera position in world
					float3 targetPos = _WorldSpaceCameraPos;

					//Object position in world
					float3 objectPos = mul (unity_ObjectToWorld, v.vertex).xyz;

					//Vertex offset from center of the object
					float3 offset = v.vertex.xyz;

					//Distance from the object to the camera
					float dist = distance(objectPos, targetPos + offset);

					//Forward vector of the camera
					float3 viewDir = UNITY_MATRIX_IT_MV[2].xyz;

					//Vector between vertex and offseted camera pos
					float3 distVec = objectPos - (targetPos + offset);

					//Angle between two vectors
					float angle = distVec - distVec;
					//float angle = atan2(normalize(cross(distVec,viewDir)), dot(distVec,viewDir));

					//Real distance (to the plane 90 degrees to camera forward and object)
					float finalDist = dist * cos(degrees(angle));

					//v.vertex *= ( 2 );
					v.vertex *= finalDist * _OutlineWidth;

					//v.vertex *= -1;

					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				#else
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					return o;
				#endif

			}

			half4 frag(v2f i) : COLOR
			{
				#if defined(_OUTLINE_NONE)
					discard;
					return half4(1,1,1,1);
				#else
					return _OutlineColor;
				#endif
			}

			ENDCG
		}
	}
	Fallback Off
}