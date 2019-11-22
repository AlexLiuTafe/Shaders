Shader "Extra/Outline"
{
    Properties
    {
		//SHADER LAB LANGUAGE
       _MainTex("Main Texture (RGB)",2D) = "white" {} //Allows for a texture property in inspector
	   _Color("Color",Color) = (1,1,1,1) //Allows for a color property

	   _OutlineTex("Outline Texture",2D) = "white" {}
	   _OutlineColor("Outline Color",Color) = (1,1,1,1)
	   _OutlineWidth("Outline Width",Range(1.0,10.0)) = 1.05

    }
    SubShader
    {
		Tags
		{
			"Queue" = "Transparent"
		}
		Pass
		{
			Name "OUTLINE"

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

			struct appdata // for vertex data information
			{
				float4 vertex : POSITION;//Get the original position
				float2 uv : TEXCOORD0;//get the original coordinate
			};

			struct v2f // v2f(vertex to fragment) - for fragment data information (fragment is the pixel)
			{
				float4 pos : SV_POSITION; //SV is for another platform (ex : PS3 platform)
				float2 uv : TEXCOORD0;
			};

			/*--------------------------------------------------------------------------
			IMPORTS -  Re-import property from shader lab to nvdia cg
			--------------------------------------------------------------------------*/
			//NVDIA CG language
			float _OutlineWidth;
			float4 _OutlineColor;
			sampler2D _OutlineTex;

			/*--------------------------------------------------------------------------
			VERTEX FUNCTION - Build the object
			--------------------------------------------------------------------------*/
			//do vertex function then the name of the function(vert) and what information that go in
			v2f vert(appdata IN)
			{
				IN.vertex.xyz *= _OutlineWidth;
				v2f OUT;// new v2f struct for output

				
				OUT.pos = UnityObjectToClipPos(IN.vertex); //Take the object into the camera perspective
				OUT.uv = IN.uv;

				return OUT;

			}
			/*--------------------------------------------------------------------------
			FRAGMENT FUNCTION - color it is in
			--------------------------------------------------------------------------*/
			fixed4 frag(v2f IN) : SV_Target //the color of the final thing
			{
				//Get the texture and wrap it around the object
				float4 texColor = tex2D(_OutlineTex, IN.uv);
				return texColor * _OutlineColor;
			}

			ENDCG
		}
		Pass
		{
			Name "OBJECT"

			CGPROGRAM//Allows talk between two languages : shader lab and nvdia C for Graphics
			/*-----------------------------------------------------------------------
			FUNCTION DEFINES - defines the name for the vertex and fragment functions
			-------------------------------------------------------------------------*/
			#pragma vertex vert // Define for the building the shape function
			#pragma fragment frag // Define for coloring functiom

			/*--------------------------------------------------------------------------
			INCLUDES
			----------------------------------------------------------------------------*/
			#include "UnityCG.cginc" // build in shader functions

			/*--------------------------------------------------------------------------
			STRUCTURES -  Can get data like - vertices, normal ,color, uv
			----------------------------------------------------------------------------*/

			struct appdata // for vertex data information
			{
				float4 vertex : POSITION;//Get the original position
				float2 uv : TEXCOORD0;//get the original coordinate
			};

			struct v2f // v2f(vertex to fragment) - for fragment data information
			{
				float4 pos : SV_POSITION; //SV is for another platform (ex : PS3 platform)
				float2 uv : TEXCOORD0;
			};

			/*--------------------------------------------------------------------------
			IMPORTS -  Re-import property from shader lab to nvdia cg
			--------------------------------------------------------------------------*/
			//NVDIA CG language
			float4 _Color;
			sampler2D _MainTex;

			/*--------------------------------------------------------------------------
			VERTEX FUNCTION - Build the object
			--------------------------------------------------------------------------*/
			//do vertex function then the name of the function(vert) and what information that go in
			v2f vert(appdata IN)
			{
				v2f OUT;// new v2f struct for output

				//Take the object from the object space into the camera clip space(make it appear on screen)
				OUT.pos = UnityObjectToClipPos(IN.vertex); 
				OUT.uv = IN.uv;

				return OUT;

			}
			/*--------------------------------------------------------------------------
			FRAGMENT FUNCTION - color it is in
			--------------------------------------------------------------------------*/
			fixed4 frag(v2f IN) : SV_Target //SV_Target is the color of the final thing
			{
				//Get the texture and wrap it around the object
				float4 texColor = tex2D(_MainTex, IN.uv);
				return texColor * _Color;
			}

			ENDCG
		}
	}
        
}
