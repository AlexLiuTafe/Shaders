Shader "Extra/FinalOutline"
{
    Properties
    {
		//SHADER LAB LANGUAGE
		_MainTex("Main Texture (RGB)",2D) = "white" {} //Allows for a texture property in inspector
	    _Color("Color",Color) = (1,1,1,1) //Allows for a color property

	    _OutlineWidth("Outline Width",Range(1.0,10.0)) = 1.05

	    _BlurRadius ("Blur Radius",Range (0.0,20.0)) = 1
        _Intensity ("Blur Intensity",Range (0.0,1.0)) = 0.1

	    _DistortColor("Distort Color", Color) = (1,1,1,1)
	    _BumpAmt("Distortion",Range (0,128)) = 10 // The intensity
	    _DistortTex("Distort Texture (RGB)",2D) = "white" {}
	    _BumpMap("Normal Map",2D) ="bump" {}
    }
    SubShader
    {
		Tags
		{
			"Queue" = "Transparent"
		}
		GrabPass{} //Render the object that is behind actual object
		UsePass "Extra/OutlineDistort/OUTLINEDISTORT"
		GrabPass{} //Render the object that is behind actual object
		UsePass "Extra/OutlineBlur/OUTLINEHORIZONTALBLUR"
		GrabPass{} //Render the object that is behind actual object
		UsePass "Extra/OutlineBlur/OUTLINEVERTICALBLUR"
		USePass "Extra/Outline/OBJECT"
	}
        
}
