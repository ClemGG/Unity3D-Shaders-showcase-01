using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawn : MonoBehaviour {

    [SerializeField] private List<Transform> prefabs;
    private float timer = 0;
    [SerializeField] private float PauseTime;

    // Update is called once per frame
    void FixedUpdate()
    {
        timer += Time.deltaTime;

        if (timer > PauseTime)
        {

            for (int i = 0; i < prefabs.Count; i++)
            {
                Instantiate(prefabs[i], transform.position, Quaternion.identity, transform);
            }
        }
    }
}
