Shader "Hidden/Shader_Pixellisation"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScreenWidth("Screen width Resolution in Pixels", float) = 64
		_ScreenHeight("Screen height Resolution in Pixels", float) = 64
		//_Resolution("Screen height Resolution in Pixels", Range(0, 300)) = 300
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
			
			//float _Resolution;
			float _ScreenWidth;
			float _ScreenHeight;
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv.x *= _ScreenWidth;
				uv.y *= _ScreenHeight;
				//uv.x *= _Resolution;
				//uv.y *= _Resolution;
				uv.x = round(uv.x);
				uv.y = round(uv.y);
				uv.x /= _ScreenWidth;
				uv.y /= _ScreenHeight;
				//uv.x /= _Resolution;
				//uv.y /= _Resolution;
				//fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = tex2D(_MainTex, uv);
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				return col;
			}
			ENDCG
		}
	}
}
