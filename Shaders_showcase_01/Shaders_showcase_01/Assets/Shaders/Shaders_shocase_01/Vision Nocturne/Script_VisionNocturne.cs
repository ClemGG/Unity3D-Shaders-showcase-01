using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView]
[ExecuteInEditMode]
public class Script_VisionNocturne : MonoBehaviour {

    
    [SerializeField] private Material Mat;

    private void OnEnable()
    {
       GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }


    [ImageEffectOpaque]
    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, Mat);
    }

}
