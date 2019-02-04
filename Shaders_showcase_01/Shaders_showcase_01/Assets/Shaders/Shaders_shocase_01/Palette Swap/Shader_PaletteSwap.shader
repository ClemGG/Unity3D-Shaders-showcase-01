// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/PaletteSwap"
{
	Properties
	{
		//Pas de _MainText nécessaire pour ce shader-là, puisque la _MainTex correspond ici à ce qu'affiche de base la caméra à l'écran
		//Mais il faut laisser le champ ici apparemment, jsp pourquoi, je pensais que c'était juste pour l'afficher dans l'Inspector, 
		//mais apparemment le shader s'en sert donc on le laisse
		_MainTex ("Main Texture", 2D) = "white" {}
		_PaletteTex("Palette Rouge", 2D) = "white" {}
		_TransitionTex("Transition Texture", 2D) = "white" {}
		_TransitionDistance("Transition Distance", Range(0.0,1.0)) = 0.5


		_PaletteScroll("Palette Scroll", Range(0.0,1.0)) = 0.5
		_ScreenWidth("Screen width Resolution in Pixels", float) = 64
		_ScreenHeight("Screen height Resolution in Pixels", float) = 64
	}
	SubShader
	{
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
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 screenPos : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _PaletteTex;
			sampler2D _TransitionTex;

			float _ScreenWidth;
			float _ScreenHeight;
			float _PaletteScroll;

			float4 origin;
			float _TransitionDistance;

			fixed4 frag (v2f i) : SV_Target
			{

				float2 uvCercle = i.uv;
				uvCercle.x *= _ScreenWidth;
				uvCercle.y *= _ScreenHeight;
				uvCercle.x = round(uvCercle.x);
				uvCercle.y = round(uvCercle.y);
				uvCercle.x /= _ScreenWidth;
				uvCercle.y /= _ScreenHeight;


				//float2 screenPos = (i.screenPos.xy/i.screenPos.w);
				float2 screenPos = i.uv;
				float distance = length(screenPos * _TransitionDistance - screenPos);

				float x = tex2D(_MainTex, i.uv).r + _PaletteScroll;

				fixed4 c =  tex2D(_TransitionTex, uvCercle);
				fixed4 d =  tex2D(_MainTex, i.uv) * (c.a >= _TransitionDistance);
				fixed4 e =  tex2D(_PaletteTex, float2(x, 0)) * (c.a < _TransitionDistance);

				//return  tex2D(_MainTex, i.uv) * (c.r < _TransitionDistance) + tex2D(_PaletteTex, float2(x, 0)) * (c.r > _TransitionDistance);

				return d + e;
			}

			ENDCG
		}
	}
}
