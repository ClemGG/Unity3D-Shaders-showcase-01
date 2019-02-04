using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PortalCamera : MonoBehaviour {

	[SerializeField] private Transform playerCam;
	[SerializeField] private Transform portal;
	[SerializeField] private Transform otherPortal;
    
    // Update is called once per frame
    void LateUpdate () {

        Vector3 playerOffsetFromPortal = playerCam.position - otherPortal.position;
        transform.position = portal.position + playerOffsetFromPortal;

        float angularDifferenceBetweenPortalRotations = Quaternion.Angle(portal.rotation, otherPortal.rotation);
        Quaternion portalRotationalDifference = Quaternion.AngleAxis(angularDifferenceBetweenPortalRotations, Vector3.up);
        Vector3 newCamDirection = portalRotationalDifference * playerCam.forward;
        transform.rotation = Quaternion.LookRotation(newCamDirection, Vector3.up);
    }
}
