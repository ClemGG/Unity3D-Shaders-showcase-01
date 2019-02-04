Shader "Unlit/Shader_Holo_Flickering"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_Alpha("Alpha", Range(0,1)) = 0.25
		_CutoutThreshold("Cutout Threshold", Range(0,1)) = 0.25
		_Distance("Distance", float) = 1
		_Amplitude("Amplitude", float) = 1
		_Speed("Speed", float) = 1
		_Amount("Amount", Range(0,1)) = 1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 100
		Zwrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Cull Off	// Le material s'applique des deux côtés de chaque face de l'objet, à l'intérieur et à l'extérieur
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _TintColor;
			float _Alpha;
			float _CutoutThreshold;
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;

			v2f vert (appdata v)
			{
				v2f o;
				v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
				col.a = _Alpha;
				//Les deux lignes suivantes font la même chose apparemment : Elles permettent de faire disparaître les couleurs que l'on veut
				//supprimer pour l'effet flickering.
				clip(col.r - _CutoutThreshold);
				//if(col.r < _CutoutThreshold) discard;
				return col;
			}
			ENDCG
		}
	}
}
