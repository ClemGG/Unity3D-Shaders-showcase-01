Shader "Custom/Unlit/Toon/Outline"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineTex ("Outline Texture", 2D) = "black" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(1.0,1.2)) = 1.05
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Transparent+1" }
		LOD 100

		Pass
		{
			Name "Pass_Outline"

			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};



			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			
			sampler2D _OutlineTex;
			float4 _OutlineColor;
			float _OutlineWidth;



			
			v2f vert (appdata v)
			{
				v.vertex.xyz *= _OutlineWidth;

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_OutlineTex, i.uv) * _OutlineColor;
				return col;
			}
			ENDCG
		}










		Pass
		{

			Name "Pass_Object"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};



			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			
			sampler2D _OutlineTex;
			float4 _OutlineColor;
			float _OutlineWidth;



			
			v2f vert (appdata v)
			{

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				return col;
			}
			ENDCG
		}
	}

	FallBack "Diffuse"
}
