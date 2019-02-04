using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalTeleporter : MonoBehaviour {

	[SerializeField] private Transform player;
	[SerializeField] private Transform receivingPortal;
	[SerializeField] private float angleBetweenPortals = 180f; // Ca c'est dans quel sens va sortir le joueur du portail

    private bool playerIsOverlapping = false;

	// Update is called once per frame
	void Update () {

        if (playerIsOverlapping)
        {

            //Pour déterminer de quel côté le joueur a traversé le portail
            Vector3 portalToPlayer = player.position - transform.position;
            float dotProduct = Vector3.Dot(transform.up, portalToPlayer);

            //Si c'est vrai, alors le joueur a traversé le portail de son côté visible
            if(dotProduct < 0f)
            {
                float rotDiff = -Quaternion.Angle(transform.rotation, receivingPortal.rotation);
                rotDiff += angleBetweenPortals;
                player.Rotate(Vector3.up, rotDiff);

                Vector3 posOffset = Quaternion.Euler(0f, rotDiff, 0f) * portalToPlayer;
                player.position = receivingPortal.position + posOffset;
                playerIsOverlapping = false;
            }
        }
	}

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            playerIsOverlapping = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            playerIsOverlapping = false;
        }
    }
}
