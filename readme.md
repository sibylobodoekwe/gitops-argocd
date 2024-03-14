Creating GKE Clusters with Terraform and Deploying Microservices with ArgoCD

Google Kubernetes Engine (GKE) clusters using Terraform and deploying microservices applications with ArgoCD. Terraform will be used to automate the infrastructure setup, while ArgoCD will handle the continuous delivery of microservices to the GKE clusters.

Prerequisites:

Terraform
Google Cloud SDK
kubectl
ArgoCD CLI

- Set Up Google Cloud Platform
Create a new project on Google Cloud Platform.
Enable the GKE API for your project.
Create a service account and download its JSON key. This service account will be used by Terraform to provision resources on GCP.

- Configure Terraform
git clone https://github.com/sibylobodoekwe/kubernetes-iaac-microservice
cd gcp-k8s-argocd


Create a terraform.tfvars file and provide the required variables:

'project_id = "your_project_id"
region     = "your_region"
'

Initialize Terraform and download the required plugins.

'terraform init'


- Create GKE Clusters

Apply the Terraform configuration to create the GKE cluster.

'terraform apply --auto-approve'

Review the changes and confirm by typing yes when prompted.


- Install ArgoCD

Install ArgoCD on the newly created GKE cluster by applying the manifest files:

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Verify that ArgoCD resources are created successfully:

kubectl get all -n argocd


- set up your ArgoCD
Access the ArgoCD UI by port-forwarding the service:

kubectl port-forward svc/argocd-server -n argocd 8080:443 

open your web browser and go to https://localhost:8080. Log in using the default username and password.

argocd admin initial-password -n argocd
change the admin password for security reasons:

argocd account update-password


- deploy sock-shop Manifest Files with ArgoCD
the microservices application has Kubernetes manifest files (e.g., deployment, service, ingress) defining each component of the application.
Organize your manifest files into a directory structure that reflects the application's architecture and dependencies.

- create ArgoCD Application: In the ArgoCD UI or via CLI, create a new application. Provide the Git repository URL where your manifest files are located and specify the directory path containing the manifests.
Sync the application after creating the ArgoCD application, Argo will retrieve the manifest files from the repo, compare them with the current state of the cluster, and apply any necessary changes.

- monitoring with Prometheus and Grafana
Deploy Prometheus: Start by deploying Prometheus to your Kubernetes cluster. You can use Helm charts or Kubernetes manifests to install Prometheus. Ensure that Prometheus is configured to scrape metrics from your microservices application.
Deploy Grafana: Next, deploy Grafana to your Kubernetes cluster. Grafana will be used to visualize the metrics collected by Prometheus. Similar to Prometheus, you can use Helm charts or Kubernetes manifests to install Grafana.

- set up domain and Ingress Create DNS Record: In order to access your microservices application from a custom domain, create a DNS record pointing to the IP address of the GKE cluster's load balancer. This can usually be found in the GCP Console under "Networking" > "Network Services" > "Load balancing."


- Ingress Rules define an Ingress resource to route traffic from the specified domain to the appropriate microservice. configure host field of the Ingress resource with your custom domain.

- apply Changes: Apply the changes to your Kubernetes cluster by syncing the ArgoCD application. Argo will detect the updated manifest files and apply the changes accordingly.

- Verify Configuration: Once the changes are applied, verify that the Ingress rules are configured correctly by accessing your microservices application using the custom domain in a web browser. Ensure that the traffic is routed to the correct microservice and that the application functions as expected.
Conclusion

your application wouuld be accessible through you custom domain, and any future updates to the application can be easily managed and deployed using ArgoCD's continuous delivery capabilities. these method would help you  navigate your microservice deployment using ArgoCD on GKE clusters. You can introduce gitlab to your argocd pipeline for continous deployment and repository management.. cc ./argocd-gitlab 
