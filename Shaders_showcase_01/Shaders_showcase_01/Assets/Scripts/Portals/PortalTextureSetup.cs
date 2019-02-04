using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalTextureSetup : MonoBehaviour {

    [SerializeField] private Camera camToDisplay;
    [SerializeField] private Material materialOfCamToDisplay;



    // Use this for initialization
    void Start () {
		
        if(camToDisplay.targetTexture != null)
        {
            camToDisplay.targetTexture.Release();
        }
        RenderTexture rend = new RenderTexture(Screen.width, Screen.height, 24);
        //rend.antiAliasing = 2; //Pour pouvoir avoir des visuels récursifs ; mais apparemment ça interfère avec le shader des portails et ça fait un rendu dégueu
        camToDisplay.targetTexture = rend;
        materialOfCamToDisplay.mainTexture = camToDisplay.targetTexture;
	}
}
