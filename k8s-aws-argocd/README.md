# kubernetes-deployment-iaac


After creating your EKS cluster using the provided Terraform configuration, you can start deploying your applications and services. Here's a step-by-step guide on how to do this:

First, ensure that you have the necessary AWS credentials configured on your system. You can do this by setting the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN environment variables.
Change to the k8s-aws-argocd directory:


cd k8s-aws-argocd
Initialize the Terraform backend:

terraform init -backend-config=etc/env_us-west-2_test.tfvars
Apply the Terraform configuration to create the necessary resources:


terraform apply -var-file=etc/env_us-west-2_test.tfvars
Once the resources have been created, you can use ArgoCD to deploy your applications and services. First, create a port-forward to the ArgoCD server:

kubectl port-forward svc/argocd-server -n argocd 8080:443
Now, you can access the ArgoCD web interface by navigating to http://localhost:8080 in your browser.

Log in using the admin username and the password stored in the argocd-server-secret secret in the argocd namespace.
Once logged in, you can view the applications and services that have been deployed using ArgoCD. You can also create new applications and services by creating new Application resources in the argocd-apps namespace.

To update an existing application, you can modify the Application resource in the argocd-apps namespace and then sync the application using the ArgoCD web interface or the argocd CLI tool.

To delete an application or service, you can delete the corresponding Application resource in the argocd-apps namespace and then sync the application using the ArgoCD web interface or the argocd CLI tool.

Finally, when you're done using the cluster, you can destroy the resources by running:

terraform destroy -var-file=etc/env_us-west-2_test.tfvars
This will delete all the resources created by the Terraform configuration.
