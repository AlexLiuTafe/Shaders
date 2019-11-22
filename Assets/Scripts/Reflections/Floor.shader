﻿Shader "Reflection/Floor"
{
    Properties
    {
        _ReflectionTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
		//Set rendermode to alphablend
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
		//Checking Value if it equal to 1 before drawing
			Stencil
			{
				Ref 1
				Comp Equal
			}
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

            sampler2D _ReflectionTex;
			float _reflectionFactor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_ReflectionTex, i.uv);
				col.a = _reflectionFactor; //Set transparancy
                return col;
            }
            ENDCG
        }
    }
}
