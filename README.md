# invideo-terraform-assignment

Terraform configuration files to provision the infrastructure for the InVideo assignment.

**Overview of the Infra Created**

- VPC with two public subnets (for EKS), four private subnets (for EKS & RDS), a NAT Gateway, an internet gateway and required route tables. (network module)
- EKS cluster with nodes in private subnet and load balancer in public subnet and relevant cluster IAM roles. (webserver module)
- RDS PostgreSQL instance in private subnet. (database module)

**PREREQUISITES**

- AWS CLI must be installed and configured with a profile having relevant IAM Permissions (preferably admin)
- Terraform must be installed
- `kubectl` must be installed

**Steps to Run**

1. Replace the `variables.tf ` file values with relevant values (at the root level as well as inside the modules, wherever relevant)
2. Create a `terraform.tfvars` file at the root level with the values for `db_username` and `db_password` for the PostgreSQL database.
3. Initialize the Terraform environment :
   `terraform init`
4. Validate the Terraform configuration :
   `terraform validate`
5. Apply the Terraform configuration :
   `terraform apply --auto-approve`
6. On successful completion of the above steps, the infrastructure will be created. Now we need to update the kubeconfig file with the credentials for the EKS cluster. We can do this by running the following command :
   `aws eks --region <region> update-kubeconfig --name <eks-cluster-name>`

We must also have the metrics-server installed in the kubernetes cluster for the HPA to work. We can do this by running the following command :
`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`

7. Now we can apply the necessary kuberenetes manifests for the InVideo assignment. We can do this by running the following commands :

   - `cd k8s-config`
   - `kubectl apply -f deployment.yml` ---> Deployment containing nginx pod configs
   - `kubectl apply -f service.yml` ---> Service containing load balancer configs
   - `kubectl apply -f nginx-config.yml` ---> ConfigMap containing config to return random text to the client
   - `kubectl apply -f hpa.yml` ---> Horizontal Pod Autoscaler to scale the nginx pods

   All objects get deployed to the default namespace for the sake of simplicity.

8. Once the configurations are applied, we can get the url of the loadbalancer by running the following command :
   `kubectl get svc`

9. Visit the loadbalancer URL. The server returns a static webpage with some random text.

10. To scale the pods, we can do the following:

- Open two terminal windows side by side
- In one terminal window, run the command
  `kubectl get hpa -w`
  This will continuously print the current status of the HPA.
- In the other terminal window, create a pod called `load-generator` :
  `kubectl run -i --tty load-generator --image=busybox /bin/sh`
  This will give us a bash shell in the pod running a busybox image. Now we can run the following command to scale the pods :
  `while true; do wget -q -O- http://<loadbalancer-url>; done`

  This basically creates an infinite loop of wget requests to the loadbalancer.

- Now go back to the previous terminal window and you should see the HPA triggering a scale out - number of pods should increase with cpu usage.

11. To destroy the infrastructure :

- first delete the kubernetes deployment, service, configmap and hpa created using the manifests.

  - `kubectl delete deployment nginx`
  - `kubectl delete service public-lb`
  - `kubectl delete configmap nginx-config`
  - `kubectl delete hpa hpa`

- Then, run the following command to destroy the terraform provisioned infrastructure :
  `terraform destroy --auto-approve`

**Results**

- Three tier architecture created:
  - Public facing load balancer in public subnet
  - Web servers (EKS Worker Nodes) in private subnet with internet access (enabled via NAT gateway-->IGW) serving static content
  - PostgreSQL database in private subnet
  - HPA to make the infrastructure scale out when CPU usage increases
  - Security groups to act as firewalls for the database
