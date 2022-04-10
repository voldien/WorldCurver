Shader"Curve/NatureCelShaded"{
	Properties{
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
	}
	SubShader{
		Name "CurvedNatureCelShaded"
		Tags {"Queue"="Transparent" "RenderType"="Transparent""DisableBatching"="False" "CanUseSpriteAtlas"="True" "IgnoreProjector"="True"	  }
		LOD 100
		ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask On

		UsePass "Curve/CelShaded/ForwardCurvedCelShaded"
		UsePass "Curve/CelShaded/DeferredCurvedCelShaded"
		UsePass "Curve/VertexLitShadow/ShadowCaster"
	}

	Fallback Off
}