using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnAvecPool : MonoBehaviour {

    ObjectPooler objectPooler;
    [SerializeField] private string tagToSpawn;
    private float timer = 0;
    [SerializeField] private float PauseTime;

    void OnEnable()
    {
        timer = 0;
    }
    private void Start()
    {
        objectPooler = ObjectPooler.instance;
    }


    // Update is called once per frame
    void FixedUpdate()
    {
        timer += Time.deltaTime;

        if (timer > PauseTime)
        {
            objectPooler.SpawnFromPool(tagToSpawn, transform.position, Quaternion.identity);
            timer = 0;
        }
        
    }
}
