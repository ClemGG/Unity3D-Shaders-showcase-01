using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ObjectPooler))]
public class ProjectileAttackSimulator : MonoBehaviour
{

    public float radius;
    public float shotCooldown;
    private float timer;
    //public GameObject projectile;

    public ObjectPooler projectilePool;
    private Transform t;


    // Use this for initialization
    void Start()
    {
        t = transform;
    }

    // Update is called once per frame
    void Update()
    {

        timer += Time.deltaTime;
        while (timer > shotCooldown)
        {
            timer -= shotCooldown;
            var point = t.position + Random.onUnitSphere * radius;
            var direction = Quaternion.LookRotation(t.position-point);
            //Instantiate(projectile, point, direction);
            projectilePool.SpawnFromPool("Projectile", point, direction);
            //Debug.Log("New Projectile");
        }
    }
}