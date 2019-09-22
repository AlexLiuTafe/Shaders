
using UnityEngine;

public class OnHoverBorder : MonoBehaviour
{
	public Material border;
	public Material nonBorder;

	private void OnMouseOver()
	{
		GetComponent<Renderer>().material = border;

	}
	private void OnMouseExit()
	{
		GetComponent<Renderer>().material = nonBorder;
	}

}
