
#First, deploy IPAM and CIS controllers
kubectl apply -f base-test/secret.yaml
kubectl apply -f base-test/5-f5-cluster-role.yaml
kubectl apply -f base-test/pvc.yaml
kubectl apply -f base-test/6-f5-ipam-deployment.yaml
kubectl apply -f base-test/7-customresourcedefinitions-mike.yaml
kubectl apply -f base-test/8-big-ip-deployment.yaml

#Wait until your IPAM controller is running. In AKS, the pvc can take a minute or so to deploy and therefore the IPAM controller will be a minute or so before being in a ready state.

#Now, deploy your demo app
kubectl apply -f example_user-test/namespace.yaml
kubectl apply -f example_user-test/deployment-hello-world.yaml
kubectl apply -f example_user-test/service-hello-world.yaml
kubectl apply -f example_user-test/virtual-server-crd.yaml

