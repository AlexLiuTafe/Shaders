Shader "Extra/Blur"
{
    Properties
    {
		//SHADER LAB LANGUAGE
		_BlurRadius ("Blur Radius",Range (0.0,20.0)) = 1
       _Intensity ("Blur Intensity",Range (0.0,1.0)) = 0.1
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
			Name "HORIZONTALBLUR"


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

			

			struct v2f // v2f(vertex to fragment) - for fragment data information (fragment is the pixel)
			{
				float4 vertex : SV_POSITION; //SV is for another platform (ex : PS3 platform)
				float4 uvgrab : TEXCOORD0;
			};

			/*--------------------------------------------------------------------------
			IMPORTS -  Re-import property from shader lab to nvdia cg
			--------------------------------------------------------------------------*/
			//NVDIA CG language
			float _BlurRadius;
			float _Intensity;
			sampler2D _GrabTexture; // from the GrabPass
			float4 _GrabTexture_TexelSize;

			/*--------------------------------------------------------------------------
			VERTEX FUNCTION - Build the object
			--------------------------------------------------------------------------*/
			//do vertex function then the name of the function(vert) and what information that go in
			v2f vert(appdata_base IN)
			{
				
				v2f OUT;// new v2f struct for output
				OUT.vertex = UnityObjectToClipPos(IN.vertex); //Take the object into the camera perspective

				#if UNITY_UV_STARTS_AT_TOP //Defining scale for specified platform
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				OUT.uvgrab.xy = (float2(OUT.vertex.x,OUT.vertex.y * scale) + OUT.vertex.w) * 0.5; //Get the object that behind the actual object
				OUT.uvgrab.zw = OUT.vertex.zw;

				return OUT;
			}
			/*--------------------------------------------------------------------------
			FRAGMENT FUNCTION - color it is in
			--------------------------------------------------------------------------*/
			half4 frag (v2f IN) : COLOR
			{
				//Get everything the Grabpass has(object that behind) and project it in the actual object material
				half4 texcol = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(IN.uvgrab)); 
				half4 texsum = half4(0,0,0,0);//apply the blur
			    //GRABPIXEL : Take the pixel color around it and Average it out (We are doing HORIZONTALBLUR : only left or right direction)
			    // weight: how much percentage of pixel color it is going to take,kernelx: what pixel in the x axis it is going to take
				//*NOTE define GRABPIXEL function has to be in 1 line
			    #define GRABPIXEL(weight, kernelx) tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(float4(IN.uvgrab.x + _GrabTexture_TexelSize.x * kernelx * _BlurRadius,IN.uvgrab.y,IN.uvgrab.z, IN.uvgrab.w))) * weight

				texsum +=GRABPIXEL(0.05, -4.0);
				texsum +=GRABPIXEL(0.09, -3.0);
				texsum +=GRABPIXEL(0.12, -2.0);
				texsum +=GRABPIXEL(0.15, -1.0);
				texsum +=GRABPIXEL(0.18, 0.0);
				texsum +=GRABPIXEL(0.15, 1.0);
				texsum +=GRABPIXEL(0.12, 2.0);
				texsum +=GRABPIXEL(0.09, 3.0);
				texsum +=GRABPIXEL(0.05, 4.0);

				//we are lerping the object by the Intensity
				texcol = lerp(texcol,texsum,_Intensity);
				return texcol;
			}
			ENDCG
		}

		GrabPass{}
		Pass
		{
			Name "VERTICALBLUR"

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
				float4 vertex : SV_POSITION; //SV is for another platform (ex : PS3 platform)
				float4 uvgrab : TEXCOORD0;
			};

			/*--------------------------------------------------------------------------
			IMPORTS -  Re-import property from shader lab to nvdia cg
			--------------------------------------------------------------------------*/
			//NVDIA CG language
			float _BlurRadius;
			float _Intensity;
			sampler2D _GrabTexture; // from the GrabPass
			float4 _GrabTexture_TexelSize;

			/*--------------------------------------------------------------------------
			VERTEX FUNCTION - Build the object
			--------------------------------------------------------------------------*/
			//do vertex function then the name of the function(vert) and what information that go in
			v2f vert(appdata_base IN)
			{
				v2f OUT;// new v2f struct for output
				OUT.vertex = UnityObjectToClipPos(IN.vertex); //Take the object into the camera perspective

				#if UNITY_UV_STARTS_AT_TOP //Defining scale for specified platform
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				OUT.uvgrab.xy = (float2(OUT.vertex.x,OUT.vertex.y * scale) + OUT.vertex.w) * 0.5; //Get the object that behind the actual object
				OUT.uvgrab.zw = OUT.vertex.zw;

				return OUT;
			}
			/*--------------------------------------------------------------------------
			FRAGMENT FUNCTION - color it is in
			--------------------------------------------------------------------------*/
			half4 frag (v2f IN) : COLOR
			{
				//Get everything the Grabpass has(object that behind) and project it in the actual object material
				half4 texcol = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(IN.uvgrab)); 
				half4 texsum = half4(0,0,0,0);//apply the blur
			    //GRABPIXEL : Take the pixel color around it and Average it out (We are doing HORIZONTALBLUR : only left or right direction)
			    // weight: how much percentage of pixel color it is going to take,kernelx: what pixel in the x axis it is going to take
				//*NOTE define GRABPIXEL function has to be in 1 line
			    #define GRABPIXEL(weight, kernely) tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(float4(IN.uvgrab.x,IN.uvgrab.y + _GrabTexture_TexelSize.y * kernely * _BlurRadius,IN.uvgrab.z, IN.uvgrab.w))) *weight

				texsum +=GRABPIXEL(0.05, -4.0);
				texsum +=GRABPIXEL(0.09, -3.0);
				texsum +=GRABPIXEL(0.12, -2.0);
				texsum +=GRABPIXEL(0.15, -1.0);
				texsum +=GRABPIXEL(0.18, 0.0);
				texsum +=GRABPIXEL(0.15, 1.0);
				texsum +=GRABPIXEL(0.12, 2.0);
				texsum +=GRABPIXEL(0.09, 3.0);
				texsum +=GRABPIXEL(0.05, 4.0);

				//we are lerping the object by the Intensity
				texcol = lerp(texcol,texsum,_Intensity);
				return texcol;
			}

			ENDCG
		}
	}
        
}
