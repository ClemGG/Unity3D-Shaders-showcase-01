Shader "Custom/Shader_2D_AmbientLightingShader 1" {
	Properties {
		[HDR] _PrimaryColor ("Primary Color", Color) = (1,1,1,1)
		[HDR] _SecondaryColor ("Secondary Color", Color) = (1,1,1,1)
		_Strength ("Mask Strength", Float) = 1
		_CutoffPoint ("Cutoff Point", Range(0,1)) = 0.5


		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MaskTex ("Mask Texture (Gradient)", 2D) = "white" {}

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
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
		sampler2D _MaskTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MaskTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _PrimaryColor;
		fixed4 _SecondaryColor;

		float _Strength;
		half _CutoffPoint;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {


			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _PrimaryColor;
			fixed4 d = tex2D (_MainTex, IN.uv_MainTex) * _SecondaryColor;
			fixed maskStrength = tex2D (_MaskTex, IN.uv_MaskTex) * _Strength;
			float maskSelection = (_CutoffPoint < maskStrength);

			o.Albedo = c.rgb * _PrimaryColor * maskSelection + (1 - maskSelection) * _SecondaryColor * d.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _PrimaryColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
