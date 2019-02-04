Shader "Custom/Shader_GlowingRippleRingWorldSpace" {
	Properties {
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		[Space(30)]
		_RingTexture ("Ring Texture", 2D) = "white" {}
		_InnerTexture ("Inner Texture", 2D) = "white" {}
		_OuterTexture ("Outer Texture", 2D) = "white" {}
		[HDR] _RingColor ("Ring Color", Color) = (1,1,1,1)
		[HDR] _InnerTextureColor ("Inner Texture Color", Color) = (1,1,1,1)
		[HDR] _OuterTextureColor ("Outer Texture Color", Color) = (1,1,1,1)
		_RippleOrigin("Ripple Origin", Vector) = (0,0,0,0)
		_RippleDistance("Ripple Distance", Float) = 1
		_RippleWidth("Ripple Width", Float) = 0.1
		_RipplePower("Ripple Power", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200



		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _RingTexture;
		sampler2D _InnerTexture;
		sampler2D _OuterTexture;

		struct Input {
			float2 uv_RingTexture;
			float2 uv_InnerTexture;
			float2 uv_OuterTexture;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;

		fixed4 _RingColor;
		fixed4 _InnerTextureColor;
		fixed4 _OuterTextureColor;

		fixed4 _RippleOrigin;
		float _RippleDistance;
		float _RippleWidth;
		float _RipplePower;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)





		void surf (Input IN, inout SurfaceOutputStandard o) {

		
			float distance = length(IN.worldPos.xyz - _RippleOrigin.xyz) - _RippleDistance;
			//For the swizzle effect, remove one of the axes x y or z of the opération. The script will ignore those axes when calculating the distance


			float halfWidth = _RippleWidth*.5;
			float lowerWidth = distance-halfWidth;
			float upperWidth = distance+halfWidth;


			fixed4 ringTex = tex2D (_RingTexture, IN.uv_RingTexture) * _RingColor;
			fixed4 innerTex = tex2D (_InnerTexture, IN.uv_InnerTexture) * _InnerTextureColor;
			fixed4 outerTex = tex2D (_OuterTexture, IN.uv_OuterTexture) * _OuterTextureColor;


			float ringStrength = pow(max(0, 1 - (abs(distance) / halfWidth)), _RipplePower) * (lowerWidth < 0 && upperWidth > 0);

			 

			o.Albedo = ((distance < 0) * innerTex.rgb) + 
						(ringStrength * ringTex.rgb) + 
						((distance > 0) * outerTex.rgb);


			o.Alpha = ringTex.a;


			o.Metallic =  _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
