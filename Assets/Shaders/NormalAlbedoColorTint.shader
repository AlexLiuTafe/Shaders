//This section allow for easy sorting of our shader
Shader "Lesson/Normal Albedo Color Tint"
{
//Are the public properties seen on the material
    Properties
	{
		_Texture("Texture",2D) = "black"{}
		//our variable is _Texture
		//our display name is "Texture"
		//it is our type of 2D
		//the default untextured color is black

		_NormalMap("Normal",2D) = "bump"{}
		//uses RGB colour to create xyz depth tp the material
		//bump tells unity this material needs to be marked as a Normal Map so it can be used correctly

		_Colour("Tint",Color)=(0,0,0,0)
		//RGBA Red Green Blue Alpha
	}
	//you can have multiple subshader
	//These runs at different GPU levels on different platform
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
			//Tags are basically key-value parts
			//Inside a SubShader tags are used to determine
			//rendering order and other parameters of a subshader

			//RenderType tag categorizes shaders into several predefined groups			
		}
		CGPROGRAM //this is the start of our C for Graphics Language
		#pragma surface MainColour Lambert
		//the surface of our model is affected by mainColour Function
		//the material type is Lambert
		//Lambert is the flat Material that has no Specular
		sampler2D _Texture; 
		// This connect our _Texture variable in the properties to our 2D _Texture Variable in CG
		sampler2D _NormalMap; 
		// This connect our _NormalMap variable in the properties to our 2D _NormalMap Variable in CG
		fixed4 _Colour;
		// Reference to the input _Colour in the Properties section
		// fixed4 is 4 small decimals
		// Let us store RGB colours
		/*
		High Precision : float = 32 bits
		Medium Precision : half = 16 bits Range -60000 to +60000
		Low Precision : fixed = 11 bits Range -2.0 to +2.0
		*/

		struct Input
		{
			float2 uv_Texture;
			//Reference to our UV Map of our model
			//UV maps are wrapping of a model(3D image that is flatten)
			float2 uv_NormalMap;
			//UV map link to the _NormalMap image
		};

		void MainColour(Input IN,inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_Texture,IN.uv_Texture).rgb * _Colour;
			//Albedo is in reference to the surface Image and RGB of our model
			//we are setting the models surface to the colour of our Texture2D
			//and matching the Texture to our models UV Mapping
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
			//NormalMap is in reference to the bump map in properties
			//UnpackNormal is required because the file is compressed
			//We need to decompress and get the true value of the Image
			//Bump maps are visible when light reflects off
			//The light is bounced off at angles according to the images RGB or XYZ values
			//This creates the illusion of depth
		}
		ENDCG//this is the end of our C for Graphics Language
	}
	FallBack "Diffuse" //if all else fails, set to standard shader(Lambert and Texture)
}
