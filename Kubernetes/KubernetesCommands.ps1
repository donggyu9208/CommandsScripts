
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