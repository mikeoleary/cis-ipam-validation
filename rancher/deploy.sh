#ensure you have updated azure/terraform.tfvars

#use terraform to deploy rancher in Azure, and a rancher workload cluster
cd azure
terraform init
terraform apply -auto-approve
cd ..
#wait 5 mins, because Rancher is still finalizing the k8s workload cluster
sleep 300
#once terraform apply is completed, run these kubectl commands
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml  --kubeconfig azure/kube_config_workload.yaml
kubectl apply -f cis-ipam-setup.yaml --kubeconfig azure/kube_config_workload.yaml
#wait 3 mins, since it will take the IPAM ctlr a few mins to start due to provisioning a PVC
sleep 180
kubectl apply -f example-app.yaml --kubeconfig azure/kube_config_workload.yaml


