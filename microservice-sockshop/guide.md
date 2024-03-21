# setting up prometheus
Connect to the kubernetes gke cluster

Connect to your Kubernetes cluster and make sure you have admin privileges to create cluster roles.

run the following commands as you need privileges to create cluster roles for this Prometheus setup.

` ACCOUNT=$(gcloud info --format='value(config.account)')`
`kubectl create clusterrolebinding owner-cluster-admin-binding \`
   ` --clusterrole cluster-admin \`
   ` --user $ACCOUNT `
    


`git clone https://github.com/sibylobodoekwe/kubernetes-iaac-microservices`
`cd microservices-sockshop`

`cd manifest-monitoring`

Execute the following command to create a new namespace named monitoring.

`kubectl create namespace monitoring`





open the file named clusterRole.yaml and copy the RBAC role.
role get, list, and watch permissions to nodes, services endpoints, pods, and ingresses. The role binding is bound to the monitoring namespace. If you have any use case to retrieve metrics from any other object, you need to add that in this cluster role.

2 Create the role using the following command.
`kubectl create -f clusterRole.yaml`


Create a file called config-map.yaml and copy the file contents from this link –> Prometheus Config File.

Step 2: Execute the following command to create the config map in Kubernetes.

`kubectl create -f config-map.yaml`

Step 2: Create a deployment on monitoring namespace using the above file.

`kubectl create  -f prometheus-deployment.yaml`
Step 3: You can check the created deployment using the following command.

`kubectl get deployments --namespace=monitoring`
You can also get details from the kubernetes dashboard


Method 1: Using Kubectl port forwarding

Using kubectl port forwarding, you can access a pod from your local workstation using a selected port on your localhost. This method is primarily used for debugging purposes.

Step 1: First, get the Prometheus pod name.

`kubectl get pods --namespace=monitoring`

The output will look like the following.

`kubectl get pods --namespace=monitoring`

NAME                                     READY     STATUS    RESTARTS   AGE
prometheus-monitoring-3331088907-hm5n1   1/1       Running   0          5m
Step 2: Execute the following command with your pod name to access Prometheus from localhost port 8080.


Note: Replace prometheus-monitoring-3331088907-hm5n1 with your pod name.

`kubectl port-forward prometheus-monitoring-3331088907-hm5n1 8080:9090 -n monitoring`

Step 3: Now, if you access http://localhost:8080 on your browser, you will get the Prometheus home page.

Method 2: Exposing Prometheus as a Service [NodePort & LoadBalancer]

To access the Prometheus dashboard over a IP or a DNS name, you need to expose it as a Kubernetes service.

Step 1: Create a file named prometheus-service.yaml and copy the following contents. We will expose Prometheus on all kubernetes node IP’s on port 30000.

Step 2: Create the service using the following command.

`kubectl create -f prometheus-service.yaml --namespace=monitoring`

Step 3: Once created, you can access the Prometheus dashboard using any of the Kubernetes node’s IP on port 30000. If you are on the cloud, make sure you have the right firewall rules to access port 30000 from your workstation.

