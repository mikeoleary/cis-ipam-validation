#ensure you have updated azure/terraform.tfvars

#use terraform to deploy rancher in Azure, and a rancher workload cluster
cd azure
terraform destroy -auto-approve
cd ..


