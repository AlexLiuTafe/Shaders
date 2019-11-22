using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlanarReflectionManager : MonoBehaviour
{
	Camera m_ReflectionCamera; //New camera to mirror the main camera
	Camera m_MainCamera;//Main Camera
	
	public Slider reflectionSlider;
	public GameObject m_ReflectionPlane;
	public Material m_FloorMaterial;

	[Range(0.0f,1.0f)]
	private float m_ReflectionFactor = 0.5f;

	RenderTexture m_RenderTarget;
    void Start()
    {

		m_ReflectionFactor = reflectionSlider.value;// Attach m_ReflectionFactor to slider
		GameObject reflectionCameraGo = new GameObject("ReflectionCamera");
		m_ReflectionCamera = reflectionCameraGo.AddComponent<Camera>();
		m_ReflectionCamera.enabled = false;


		m_MainCamera = Camera.main;
		//																stencil buffer
		m_RenderTarget = new RenderTexture(Screen.width, Screen.height, 24);
    }
	private void Update()
	{
		//Reflection intensity base on slider value
		Shader.SetGlobalFloat("_reflectionFactor", reflectionSlider.value);
	}
	void OnPostRender()
	{
		RenderReflection();
	}
    void RenderReflection()
	{
		m_ReflectionCamera.CopyFrom(m_MainCamera);

		Vector3 cameraDirectionWorldSpace = m_MainCamera.transform.forward;
		Vector3 cameraUpWorldSpace = m_MainCamera.transform.up;
		Vector3 cameraPositionWorldSpace = m_MainCamera.transform.position;

		//Transform the vectors to the floor's space
		Vector3 cameraDirectionPlaneSpace = m_ReflectionPlane.transform.InverseTransformDirection(cameraDirectionWorldSpace);
		Vector3 cameraUpPlaneSpace = m_ReflectionPlane.transform.InverseTransformDirection(cameraUpWorldSpace);
		Vector3 cameraPositionPlaneSpace = m_ReflectionPlane.transform.InverseTransformPoint(cameraPositionWorldSpace);

		//Mirror the vectors
		cameraDirectionPlaneSpace.y *= -1.0f;
		cameraUpPlaneSpace.y *= -1.0f;
		cameraPositionPlaneSpace.y *= -1.0f;

		//Transform the vectors back to world space
		cameraDirectionWorldSpace = m_ReflectionPlane.transform.TransformDirection(cameraDirectionPlaneSpace);
		cameraUpWorldSpace = m_ReflectionPlane.transform.TransformDirection(cameraUpPlaneSpace);
		cameraPositionWorldSpace = m_ReflectionPlane.transform.TransformPoint(cameraPositionPlaneSpace);

		//set camera position and rotation
		m_ReflectionCamera.transform.position = cameraPositionWorldSpace;
		m_ReflectionCamera.transform.LookAt(cameraPositionWorldSpace + cameraDirectionWorldSpace, cameraUpWorldSpace);

		//Set the render target for the reflection camera
		m_ReflectionCamera.targetTexture = m_RenderTarget;

		//Render the reflection Camera
		m_ReflectionCamera.Render();

		//Draw full screen quad
		DrawQuad();
	}

	void DrawQuad()
	{
		GL.PushMatrix();

		//Set Material to draw quad
		m_FloorMaterial.SetPass(0);
		m_FloorMaterial.SetTexture("_ReflectionTex", m_RenderTarget);
		GL.LoadOrtho();

		GL.Begin(GL.QUADS);
		GL.TexCoord2(1.0f, 0.0f);
		GL.Vertex3(0.0f, 0.0f, 0.0f);//Draw Box
		GL.TexCoord2(1.0f, 1.0f);
		GL.Vertex3(0.0f, 1.0f, 0.0f);
		GL.TexCoord2(0.0f, 1.0f);
		GL.Vertex3(1.0f, 1.0f, 0.0f);
		GL.TexCoord2(0.0f, 0.0f);
		GL.Vertex3(1.0f, 0.0f, 0.0f);
		
		GL.End();

		GL.PopMatrix();
	}
}
