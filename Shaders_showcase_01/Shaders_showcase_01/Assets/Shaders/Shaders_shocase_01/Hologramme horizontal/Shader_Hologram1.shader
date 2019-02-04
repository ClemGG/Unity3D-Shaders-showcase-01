// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Shader_Hologram1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//Rendre négative la fréquence ou la vitesse inverse le sens de défilement de l'hologramme
		_Frequency ("Fréquence d'itération", Range(-1000, 1000)) = 100
		_Speed ("Vitesse d'itération", Range(-1000, 1000)) = 100
		_Bias ("Bias", Range(-1, 2)) = 0
		_Color ("Color", Color) = (1,0,0,1)
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 100
		Zwrite Off
		Blend SrcAlpha One
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 objVertex : TEXCOORD1;
			};

			fixed4 _Color;
			int _Frequency;
			int _Speed;
			float _Bias;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				//Object Space
				//o.objVertex = v.vertex;

				//World Space
				o.objVertex = mul(unity_ObjectToWorld, v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				col = _Color * max(0,cos(i.objVertex.y * _Frequency + _Time.x * _Speed) + _Bias);
				return col;
			}
			ENDCG
		}
	}
}
