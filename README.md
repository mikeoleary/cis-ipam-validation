# cis-ipam-validation
This repo is simply for troubleshooting CIS and IPAM controller. It is not intended to be a long-lived repo.

## Instructions

1. Clone this repo
````
git clone https://github.com/mikeoleary/cis-ipam-validation
````
2. Create an Azure app registration (eg, ```az ad sp create-for-rbac```) and put the details of the app id, secret, subscription and tenant in the file ```rancher/azure/terraform.tfvars```

3. Change directory to our deployment directory and run terraform to deploy our environment:
````
cd cis-ipam-validation/rancher
./deploy.sh
```` 
4. Check logs of IPAM and CIS pods, and view GUI of BIG-IP. Virtual Server should be created on BIG-IP.
  * Remember, if you are verifying via the BIG-IP GUI, to switch to the appropriate partition (top right corner of the GUI).
5. When done, you can use ```destroy.sh``` to clean up the resources created.
