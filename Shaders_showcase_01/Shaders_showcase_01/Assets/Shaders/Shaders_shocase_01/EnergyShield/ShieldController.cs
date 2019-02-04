using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShieldController : MonoBehaviour
{
    private static readonly Vector4[] defaultEmptyVector = new Vector4[] { new Vector4(0, 0, 0, 0) };

    public int size = 50;
    public Vector4[] points;

    public Material shieldMaterial;

    // Use this for initialization
    void Start()
    {
        points = new Vector4[size];
    }

    // Update is called once per frame
    void Update()
    {
        shieldMaterial.SetInt("_PointsSize", size);
        if (points.Length <= 0)
        {
            shieldMaterial.SetVectorArray("_Points", defaultEmptyVector);
            print("Using the default empty vector.");
        }
        else
        {
            shieldMaterial.SetVectorArray("_Points", points);
        }
    }
}