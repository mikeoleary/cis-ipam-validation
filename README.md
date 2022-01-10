# cis-ipam-validation
This repo is simply for troubleshooting CIS and IPAM controller. It is not intended to be a long-lived repo.

## Prerequisites
1. To run the troubleshooting, you should already have a k8s cluster configured. 
2. My testing was done on a cluster in AKS, where I specified k8s version 1.20.9. If your k8s platform is different, you may have to edit the file ```base-test/pvc.yaml``` so that you can create a PVC that is appropriate to your environment, and start your IPAM controller.

## Instructions
1. Deploy a k8s cluster
2. Deploy a BIG-IP with LTM and GTM modules provisioned. 
  * Mgmt IP address is assumed to be 10.0.1.4 but this can be configured in ```base-test/8-big-ip-deployment.yaml```
  * Username and password of BIG-IP must be updated in ```base-test/secret.yaml``` or, configure the admin username of your BIG-IP to match the value from this secret (DefaultPass12345!). Obviously, never use this password in production.
3. Run the commands listed in ```deploy.sh``` to provision the resources in k8s.
  * In my environment, the PVC takes around 60 seconds to provision in Azure. So your validation should be done after the IPAM and CIS controller are up and running.
4. Check logs of IPAM and CIS pods, and view GUI of BIG-IP. Virtual Server should be created on BIG-IP.
  * Remember, if you are verifying via the BIG-IP GUI, to switch to the appropriate partition (top right corner of the GUI).
5. When done, you can use ```destroy.sh``` to clean up the resources created in k8s.
