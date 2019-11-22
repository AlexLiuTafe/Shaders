Shader "Extra/OutlineDistort"
{
    Properties
    {
		//SHADER LAB LANGUAGE
		_DistortColor("Distort Color", Color) = (1,1,1,1)
		_BumpAmt("Distortion",Range (0,128)) = 10 // The intensity
		_DistortTex("Distort Texture (RGB)",2D) = "white" {}
		_BumpMap("Normal Map",2D) ="bump" {}
		_OutlineWidth("Outline Width",Range(1.0,10.0)) = 1.05
    }
    SubShader
    {
		Tags
		{
			"Queue" = "Transparent"
		}
		GrabPass{} //Render the object that is behind actual object
		Pass
		{
			Name "OUTLINEDISTORT"

			ZWrite Off

			CGPROGRAM//Allows talk between two languages : shader lab and nvdia C for Graphics
			/*-----------------------------------------------------------------------
			FUNCTION DEFINES - defines the name for the vertex and fragment functions
			-------------------------------------------------------------------------*/
			#pragma vertex vert // Define for the building the shape function
			#pragma fragment frag // Define for coloring function

			/*--------------------------------------------------------------------------
			INCLUDES
			----------------------------------------------------------------------------*/
			#include "UnityCG.cginc" // build in shader functions

			/*--------------------------------------------------------------------------
			STRUCTURES -  Can get data like - vertices, normal ,color, uv
			----------------------------------------------------------------------------*/

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f // v2f(vertex to fragment) - for fragment data information (fragment is the pixel)
			{
				float4 vertex : SV_POSITION; //SV is for another platform (ex : PS3 platform)
				float4 uvgrab : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
				float uvmain : TEXCOORD2;
			};

			/*--------------------------------------------------------------------------
			IMPORTS -  Re-import property from shader lab to nvdia cg
			--------------------------------------------------------------------------*/
			//NVDIA CG language
			float _BumpAmt;
			float4 _BumpMap_ST;
			float4 _DistortTex_ST;

			fixed4 _DistortColor;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _BumpMap;
			sampler2D _DistortTex;
			float _OutlineWidth;

			/*--------------------------------------------------------------------------
			VERTEX FUNCTION - Build the object
			--------------------------------------------------------------------------*/
			//do vertex function then the name of the function(vert) and what information that go in
			v2f vert(appdata IN)
			{
				IN.vertex.xyz *= _OutlineWidth;
				v2f OUT;// new v2f struct for output
				OUT.vertex = UnityObjectToClipPos(IN.vertex); //Take the object into the camera perspective

				#if UNITY_UV_STARTS_AT_TOP //Defining scale for specified platform
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				OUT.uvgrab.xy = (float2(OUT.vertex.x,OUT.vertex.y * scale) + OUT.vertex.w) * 0.5; //Get the object that behind the actual object
				OUT.uvgrab.zw = OUT.vertex.zw;

				OUT.uvbump = TRANSFORM_TEX(IN.texcoord, _BumpMap);
				OUT.uvmain = TRANSFORM_TEX(IN.texcoord, _DistortTex);

				return OUT;
			}
			/*--------------------------------------------------------------------------
			FRAGMENT FUNCTION - color it is in
			--------------------------------------------------------------------------*/
			half4 frag (v2f IN) : COLOR
			{
				//offset the material of the bump map depending of the _BumpAmt
				half2 bump = UnpackNormal(tex2D(_BumpMap,IN.uvbump)).rg;
				float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
				IN.uvgrab.xy = offset * IN.uvgrab.z + IN.uvgrab.xy;

				half4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(IN.uvgrab));//grab the distort color from the texture
				half4 tint = tex2D(_DistortTex,IN.uvmain) * _DistortColor;

				return col * tint;
			}
			ENDCG
		}
	}
        
}
