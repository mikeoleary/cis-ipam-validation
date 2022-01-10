
#delete everything in reverse order of creation
kubectl delete -f example_user-test/virtual-server-crd.yaml
kubectl delete -f example_user-test/service-hello-world.yaml
kubectl delete -f example_user-test/deployment-hello-world.yaml
kubectl delete -f example_user-test/namespace.yaml

kubectl delete -f base-test/8-big-ip-deployment.yaml
kubectl delete -f base-test/7-customresourcedefinitions-mike.yaml
kubectl delete -f base-test/6-f5-ipam-deployment.yaml
kubectl delete -f base-test/pvc.yaml
kubectl delete -f base-test/6-f5-ipam-deployment.yaml
kubectl delete -f base-test/5-f5-cluster-role.yaml
kubectl delete -f base-test/secret.yaml


