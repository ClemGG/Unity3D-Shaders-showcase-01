using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

public class Change_PostProcessing : MonoBehaviour {


    [SerializeField] private Camera thisCam;
    [SerializeField] private Camera playerCam;
    [SerializeField] private Transform player;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
            Assign_New_Post_Processing();
    }

    private void Assign_New_Post_Processing()
    {
            //Pour déterminer de quel côté le joueur a traversé le portail
            Vector3 portalToPlayer = player.position - transform.position;
            float dotProduct = Vector3.Dot(transform.up, portalToPlayer);

            //Si c'est vrai, alors le joueur a traversé le portail de son côté visible
            if (dotProduct > 0f)
            {
                playerCam.GetComponent<PostProcessingBehaviour>().profile = thisCam.GetComponent<PostProcessingBehaviour>().profile;
                playerCam.RemoveAllCommandBuffers();
            }
        
    }
}
