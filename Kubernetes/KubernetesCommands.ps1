#################
# Configuration #
#################
# Azure 
az login --tenant $tenantID
az aks create --resource-group $resourceGroup --name $aksName --location $location --node-count $nodeCount --enable-addons monitoring --kubernetes-version $aksVersion --generate-ssh-keys --windows-admin-password $pwd --windows-admin-username $username --enable-vmss --network-plugin azure --workspace-resource-id $azWorkspaceID
az aks get-credentials --name $name --resource-group $resourceGroup #--subscription $subscription # Get access credentials for a managed Kubernetes cluster
az aks browse --name $aksName --resource-group $resGroup # Show the dashboard for a Kubernetes cluster in a web browser

# Scheduling
# ConfigMap Scheduler Algorithm
https://github.com/kubernetes/community/blob/master/contributors/devel/sig-scheduling/scheduler_algorithm.md
finalScoreNodeA = (weight1 * priorityFunc1) + (weight2 * priorityFunc2)
# Default configmap
https://github.com/kubernetes/kubernetes/blob/3e7c787d3ae8d03de55c1c3e64fd1d41437c6bd4/pkg/scheduler/algorithmprovider/defaults/defaults.go
# Default Predicates
https://github.com/kubernetes/kubernetes/blob/3e7c787d3ae8d03de55c1c3e64fd1d41437c6bd4/pkg/scheduler/algorithm/predicates/predicates.go

########
# Pods #
########
# Get Pods
kubectl get pods --namespace $namespace
kubectl get pods -n $namespace

# pod logs
kubectl logs $podName --namespace $namespace
kubectl logs -n <namespace> <podName> --limit-bytes=0 --since-time=<time> --tail=10 --timestamps=true
kubectl logs -n namespace podName-58d7f87f-8tp6p --since-time="2019-09-17T15:53:35Z" --timestamps=true --limit-bytes=90000

# Copy files to a pod
kubectl cp "<Local Destination File Path>" "<PodName>:<FilePath>" -n <Namespace>
kubectl cp /Users/donglee/Downloads/somefile.js podname-c57b45986-ghcdh:/somefile.js -n <namespace>

# Copy files from a pod
kubectl cp "<PodName>:<FilePath>" "<Local Destination File Path>" -n <Namespace>

# Exec 
kubectl exec -n $namespace $webPod -- powershell "cp -r -force 'C:\mnt\azure\WebSites\*' 'C:\'" 

# Force Delete pods # This only removes the reference to the pods, it does not actually kill the pod
kubectl delete pods $pod --grace-period=0 --force -n $namespace

#############
# Namespace #
#############
# Get Namespaces
kubectl get namespaces

##############
# Deployment #
##############
# Scale
$deployment = "Deployment/app"
kubectl scale --replicas=2 --namespace $namespace $deployment

# Set deployment image
kubectl set image deployment/app web=$imageTag --namespace $namespace

########
# Jobs #
########
kubectl delete jobs/$jobName -n $namespace

#########
# Nodes #
#########
#Safely Drain a Node while Respecting the PodDisruptionBudget
kubectl get nodes
kubectl cordon <node name>
kubectl drain <node name>
kubectl uncordon <node name>