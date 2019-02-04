using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Script_ScreenColor : MonoBehaviour
{
    [SerializeField] private Material Mat;

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, Mat);
    }


    public Material _Mat
    {
        get { return Mat; }
        set { Mat = value; }
    }
}