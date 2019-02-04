Shader "Custom/Shader_Triplanar" {
	Properties {

		_DispTex ("Displacement or Normal Texture", 2D) = "white" {}
		_Displacement ("Displacement", Range(0,1)) = 0.5
		_EdgeLength ("Edge Length", Range(2,50)) = 5
		_Phong ("Phong Strength", Range(0,1)) = 0.5
		_Size ("Size", float) = 4

		[Space][Space][Space][Space][Space][Space][Space]

		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert tessellate:tessellationEdge tessPhong:_Phong nolightmap
		#include "Tessellation.cginc"
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 4.6

		sampler2D _MainTex;


		struct appdata {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float3 worldNormal;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)
		

		float _Phong;
		float _EdgeLength;


		float4 tessellationEdge(appdata v0, appdata v1, appdata v2) {
			return UnityEdgeLengthBasedTess(v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}



		sampler2D _DispTex;
		float _Displacement;
		float _Size;



		void vert (inout appdata v) {
			float d = tex2Dlod(_DispTex, float4(v.texcoord.xy,0,0)).r * _Displacement;
			v.vertex.xyz += v.normal * d;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {

		float3 vNormalInObjectSpace = normalize(mul(unity_WorldToObject, float4(IN.worldNormal, 0.0)));
		vNormalInObjectSpace = abs(vNormalInObjectSpace);
		vNormalInObjectSpace.x = abs(vNormalInObjectSpace.x);
		vNormalInObjectSpace.y = abs(vNormalInObjectSpace.y);
		vNormalInObjectSpace.z = abs(vNormalInObjectSpace.z);
		float3 vPositionInObjectSpace = (mul(unity_WorldToObject, float4(IN.worldPos, 0.0)));


		fixed4 topColor = tex2D(_MainTex, float2(vPositionInObjectSpace.x, vPositionInObjectSpace.z) * _Size);
		fixed4 forwardColor = tex2D(_MainTex, float2(vPositionInObjectSpace.x, vPositionInObjectSpace.y) * _Size);
		fixed4 rightColor = tex2D(_MainTex, float2(vPositionInObjectSpace.y, vPositionInObjectSpace.z) * _Size);


			// Albedo comes from a texture tinted by color
			fixed4 c =	rightColor * vNormalInObjectSpace.x + topColor * vNormalInObjectSpace.y + forwardColor * vNormalInObjectSpace.z;		//tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb * _Color;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
