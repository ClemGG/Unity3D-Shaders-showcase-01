using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddForce : MonoBehaviour, IPooledObject {


    [SerializeField] private float upForce = 1f;
    [SerializeField] private float sideForce = .1f;

    // Use this for initialization
    public void OnObjectSpawn () {

        float xForce = Random.Range(-sideForce,sideForce);
        float yForce = Random.Range(-upForce, upForce);
        float zForce = Random.Range(-sideForce, sideForce);

        Vector3 newForce = new Vector3(xForce, yForce, zForce);

        GetComponent<Rigidbody>().velocity = newForce;

    }
	
}
