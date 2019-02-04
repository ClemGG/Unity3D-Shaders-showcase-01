// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Image Effect/Shader_DistorsionHorizontale"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Frequency ("Frequency of the horizontal waves", Range(0,300)) = 50
		_Period ("Period of the horizontal waves", Range(0,10)) = 1
		_Size ("Size of the horizontal waves", Range(0,300)) = 50
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			


			sampler2D _MainTex;
			float _Frequency;
			float _Period;
			float _Size;


			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + float2(0, sin(i.vertex.x / _Frequency + _Time[1] * _Period) / _Size));
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				return col;
			}
			ENDCG
		}
	}
}
