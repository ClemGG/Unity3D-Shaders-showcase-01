using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldProjectile : MonoBehaviour
{

    public float projectileBias = 0.25f;
    public float speed = 10;


    private Transform t;
    public LayerMask whatIsShield;



    // Use this for initialization
    void Start()
    {
        t = transform;
    }

    // Update is called once per frame
    void Update()
    {
        float distance = speed * Time.deltaTime;
        this.t.position += this.t.forward * distance;

        Ray ray = new Ray(this.t.position, this.t.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, distance + projectileBias, whatIsShield))
        {
            hit.collider.gameObject.SendMessage("OnProjectileHit", hit.point, SendMessageOptions.DontRequireReceiver);
            //Destroy(this.gameObject);
            gameObject.SetActive(false);
        }
    }
}