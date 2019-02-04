using EZObjectPools;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnEZ : MonoBehaviour {

    [SerializeField] private EZObjectPool ez;
    private float timer = 0;
    [SerializeField] private float PauseTime;

    void OnEnable()
    {
        timer = 0;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        timer += Time.deltaTime;

        if (timer > PauseTime)
        {
            ez.TryGetNextObject(transform.position, transform.rotation);
            timer = 0;
        }
    }
}
