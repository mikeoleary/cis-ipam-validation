#ensure you have updated azure/terraform.tfvars

#use terraform to deploy rancher in Azure, and a rancher workload cluster
cd azure
terraform init
terraform apply -auto-approve

#once terraform apply is completed, run these kubectl commands
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml  --kubeconfig azure/kube_config_workload.yaml
kubectl apply -f cis-ipam-setup.yaml --kubeconfig azure/kube_config_workload.yaml
kubectl apply -f example-app.yaml --kubeconfig azure/kube_config_workload.yaml


