Shader "Unlit/Shader_ScreenColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Hue ("Hue", Range(0,360)) = 0
		_Glow ("Glow", Range(0,10)) = 1
		_Brightness ("Brightness", Range(-2,2)) = 0
		_Contrast ("Contrast", Range(1,2)) = 1
		_Saturation ("Saturation", Range(0,20)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		// No culling or depth
		//Pour rendre l'objet invisible. Teste-le sur un objet au pif si tu t'en souviens pas
		//Cull Off ZWrite Off ZTest Always
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _Hue;
			float _Glow;
			float _Brightness;
			float _Contrast;
			float _Saturation;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			inline float3 applyHue(float3 aColor, float aHue)
			{
				float angle = radians(aHue);
				float3 k = float3(0.57735, 0.57735, 0.57735);
				float cosAngle = cos(angle);
				//Rodrigues' rotation formula
				return aColor * cosAngle + cross(k, aColor) * sin(angle) + k * dot(k, aColor) * (1 - cosAngle);
			}
 
 
			inline float4 applyHSBEffect(float4 startColor)
			{

				float4 outputColor = startColor;
				outputColor.rgb = applyHue(outputColor.rgb, (_Hue * _Color));
				outputColor.rgb = (outputColor.rgb - 0.5f) * (_Contrast) + 0.5f;
				outputColor.rgb = outputColor.rgb + _Brightness;        
				float3 intensity = dot(outputColor.rgb, float3(0.299,0.587,0.114));
				outputColor.rgb = lerp(intensity, outputColor.rgb, _Saturation);
 
				return outputColor;
			}


			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _Color * _Glow;
				return applyHSBEffect(col);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
