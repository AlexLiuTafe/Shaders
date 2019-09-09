//This section allow for easy sorting of our shader
Shader "Lesson/Albedo"
{
//Are the public properties seen on the material
    Properties
	{
		_Texture("Texture",2D) = "black"{}
		//our variable is _Texture
		//our display name is "Texture"
		//it is our type of 2D
		//the default untextured color is black
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
		struct Input
		{
			float2 uv_Texture;
			//Reference to our UV Map of our model
			//UV maps are wrapping of a model(3D image that is flatten)
		};

		void MainColour(Input IN,inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_Texture,IN.uv_Texture).rgb;
			//Albedo is in reference to the surface Image and RGB of our model
			//we are setting the models surface to the colour of our Texture2D
			//and matching the Texture to our models UV Mapping
		}
		ENDCG//this is the end of our C for Graphics Language
	}
	FallBack "Diffuse" //if all else fails, set to standard shader(Lambert and Texture)
}
