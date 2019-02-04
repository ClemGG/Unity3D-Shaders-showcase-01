using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GlowingRing : MonoBehaviour {

    [SerializeField] private Material[] mats;
	
	// Update is called once per frame
	void Update () {
        for (int i = 0; i < mats.Length; i++)
        {
            mats[i].SetVector("_RippleOrigin", transform.position);

        }
    }

    private void OnApplicationQuit()
    {
        for (int i = 0; i < mats.Length; i++)
        {
            mats[i].SetVector("_RippleOrigin", Vector4.zero);

        }
    }
    private void OnDisable()
    {
        for (int i = 0; i < mats.Length; i++)
        {
            mats[i].SetVector("_RippleOrigin", Vector4.zero);

        }
    }
}
