# Solution

Create the namespace `pisces` with the following command:

```
$ kubectl create namespace pisces
namespace/pisces created
```

Create all objects with the command `kubectl create -f <yaml-manifest> -n pisces`. The Deployment will fail due to misconfiguration.

```
$ kubectl create -f web-app-service.yaml -n pisces
service/web-app-service created
$ kubectl create -f web-app-deployment.yaml -n pisces
The Deployment "web-app" is invalid: spec.template.metadata.labels: Invalid value: map[string]string{"app":"myapp"}: `selector` does not match template `labels
```

Fix the YAML manifest of the Deployment. The label selector should use the key `myapp`.

```
$ vim web-app-deployment.yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  ...
$ kubectl create -f web-app-deployment.yaml -n pisces
deployment.apps/web-app created
```

List all the objects in the namespace.

```
$ kubectl get all -n pisces
NAME                           READY   STATUS    RESTARTS   AGE
pod/web-app-7474d7bbfd-f785r   1/1     Running   0          107s
pod/web-app-7474d7bbfd-qmxz4   1/1     Running   0          107s
pod/web-app-7474d7bbfd-x9bjf   1/1     Running   0          107s

NAME                      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/web-app-service   NodePort   10.109.210.104   <none>        3000:31759/TCP   2m10s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-app   3/3     3            3           107s
```

Get the IP address of the node.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   147d   v1.22.3   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:31759
Hello World
```

Delete the namespace.

```
$ kubectl delete namespace pisces
namespace "pisces" deleted
```