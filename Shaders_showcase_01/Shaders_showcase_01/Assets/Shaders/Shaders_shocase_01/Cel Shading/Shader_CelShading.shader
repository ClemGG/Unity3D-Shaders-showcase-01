// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// WATCH FULL EXPLANATION ON YOUTUBE-VIDEO: https://www.youtube.com/watch?v=3qBDTh9zWrQ
 
Shader "Unlit/Shader_CelShading" {
   Properties {
    
    // Levels
      _SpecularColor ("SPECULAR COLOR", Color) = (1,1,1,1)
      _Specular      ("    Specular size", Range(0.5,1)) = 0.72
      _FadeSpecular  ("    Specular blur", Range(0,1)) = 0

      _DiffuseColor  ("DIFFUSE COLOR", Color) = (0.5,0.5,0.5,1) 
      _Diffuse       ("    Diffuse size", Range(-0.1,1)) = 0.1
      _FadeDiffuse   ("    Diffuse blur", Range(0,1)) = 0

      _ShadowColor   ("SHADOW COLOR", Color) = (0.25,0.25,0.25,1)
      _FadeShadow    ("    Shadow blur", Range(0,1)) = 0


      _OutlineColor ("OUTLINE COLOR", Color) = (0,0,0,0)
      _Outline ("    Outline size", Range(0,1)) = 0.3
    
    // Texture
      _MainTex ("TEXTURE", 2D) = "EnemyEmission" {}
      _TexAlpha ("    Texture alpha", Range(0,1)) = 0
  }
   
  SubShader {
    Pass {
      Tags{ "LightMode" = "ForwardBase" }
      // pass for ambient light and first light source
    
      CGPROGRAM
      
      #pragma vertex vert 
      //tells the cg to use a vertex-shader called vert
      #pragma fragment frag
      //tells the cg to use a fragment-shader called frag
      
      //== User defined ==//
      
      //TOON SHADING UNIFORMS

      uniform float4 _DiffuseColor;
      uniform float4 _ShadowColor;
      uniform float4 _SpecularColor;

      uniform float _Diffuse;
      uniform float _FadeDiffuse;
      
      uniform float _Specular;
      uniform float _FadeSpecular;

      
      uniform float _Outline;
      uniform float _FadeShadow;

      uniform float4 _OutlineColor;
      uniform float _TexAlpha;

    
      
      //== UNITY defined ==//
      uniform float4 _LightColor0;
      uniform sampler2D _MainTex;
      uniform float4 _MainTex_ST;       
      
      struct vertexInput {
        //TOON SHADING VAR
        float4 vertex : POSITION;
        float3 normal : NORMAL;
        float4 texcoord : TEXCOORD0; 
      };
      
      struct vertexOutput {
        float4 pos : SV_POSITION;
        float3 normalDir : TEXCOORD1;
        float4 lightDir : TEXCOORD2;
        float3 viewDir : TEXCOORD3;
        float2 uv : TEXCOORD0; 
      };
      
      vertexOutput vert(vertexInput input){
        vertexOutput output;
        
        //normalDirection
        output.normalDir = normalize ( mul( float4( input.normal, 0.0 ), unity_WorldToObject).xyz );
        
        //World position
        float4 posWorld = mul(unity_ObjectToWorld, input.vertex);
        
        //view direction
        output.viewDir = normalize( _WorldSpaceCameraPos.xyz - posWorld.xyz ); //vector from object to the camera
        
        //light direction
        float3 fragmentToLightSource = ( _WorldSpaceCameraPos.xyz - posWorld.xyz);
        output.lightDir = float4(
          normalize( lerp(_WorldSpaceLightPos0.xyz , fragmentToLightSource, _WorldSpaceLightPos0.w) ),
          lerp(1.0 , 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
        );
        
        //fragmentInput output;
        output.pos = UnityObjectToClipPos( input.vertex );  
        
        //UV-Map
        output.uv =input.texcoord;
        
        return output;
        
      }
      
      float4 frag(vertexOutput input) : COLOR {
        float nDotL = saturate(dot(input.normalDir, input.lightDir.xyz)); 
        
        //Diffuse threshold calculation
        float diffuseCutoff = saturate( ( max(_Diffuse, nDotL) - _Diffuse ) * (1-_FadeDiffuse) *60 );
            
        //Specular threshold calculation
        float specularCutoff = saturate( max(_Specular, dot(reflect(-input.lightDir.xyz, input.normalDir), input.viewDir))-_Specular ) * (1-_FadeSpecular) * 100;
            
        //Calculate Outlines
        float outlineStrength = saturate( (dot(input.normalDir, input.viewDir ) - _Outline) * (1-_FadeShadow) * 200 );
          
            
        float3 ambientLight = (1-_TexAlpha) *(1-diffuseCutoff) * _ShadowColor.xyz + _TexAlpha * tex2D(_MainTex, input.uv);
        float3 diffuseReflection = (1-specularCutoff) * _DiffuseColor.xyz * diffuseCutoff;
        float3 specularReflection = _SpecularColor.xyz * specularCutoff;
          
		//La première ligne n'affiche par l'outliner noir sur le modèle, mais la deuxième l'utilise.
        //float3 combinedLight = _OutlineColor * (1-outlineStrength) + (ambientLight + diffuseReflection)/* * outlineStrength */ + specularReflection;
        float3 combinedLight = _OutlineColor * (1-outlineStrength) + (ambientLight + diffuseReflection) * outlineStrength + specularReflection;
        return float4(combinedLight, 1.0);
      }
      ENDCG
    }
  }

  Fallback "Diffuse"
}﻿