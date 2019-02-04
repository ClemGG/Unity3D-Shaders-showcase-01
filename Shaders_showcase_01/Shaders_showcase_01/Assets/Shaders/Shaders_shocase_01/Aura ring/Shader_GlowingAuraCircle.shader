Shader "Custom/Shader_GlowingAuraCircle" {
	Properties {
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		[Space(30)]
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		[HDR] _RingColor ("Ring Color", Color) = (1,1,1,1)
		_RippleOrigin("Ripple Origin", Vector) = (0,0,0,0)
		_RippleDistance("Ripple Distance", Float) = 1
		_RippleWidth("Ripple Width", Float) = 0.1
		_RipplePower("Ripple Power", Float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;

		fixed4 _RingColor;
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

			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _RingColor;

			//(Un)comment both lines below to invert the ring effect
			//float ringStrength = pow(max(0,(abs(distance) / _RippleWidth)), _RipplePower) * (distance < 0);
			float ringStrength = pow(max(0, 1 - (abs(distance) / _RippleWidth)), _RipplePower) * (distance < 0);

			 

			o.Albedo = ringStrength * c.rgb;
			o.Alpha = ringStrength * c.a;


			o.Metallic =  _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
