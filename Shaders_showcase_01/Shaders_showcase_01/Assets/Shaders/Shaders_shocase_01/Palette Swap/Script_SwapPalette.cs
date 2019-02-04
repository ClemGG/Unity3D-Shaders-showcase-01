using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Script_SwapPalette : MonoBehaviour
{
    public Texture Palette;
    [Range(0f, 1f)] public float rampOffset;
    [Range(0f, 1f)] public float transitionDistance;
    public Material _mat;

    //void OnEnable()
    //{
    //    Shader shader = Shader.Find("Hidden/PaletteSwapLookup");
    //    if (_mat == null)
    //        _mat = new Material(shader);
    //}

    //void OnDisable()
    //{
    //    if (_mat != null)
    //        DestroyImmediate(_mat);
    //}

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (Palette && _mat)
        {
            _mat.SetTexture("_PaletteTex", Palette);

            _mat.SetFloat("_PaletteScroll", rampOffset);

            _mat.SetFloat("_TransitionDistance", transitionDistance);
            Graphics.Blit(src, dst, _mat);
        }
    }


}