# Solution

Create the namespace `leo` with the following command:

```
$ kubectl create namespace leo
namespace/leo created
```

Create all objects with the command `kubectl create -f <yaml-manifest> -n leo`.

```
$ kubectl create -f web-app-pod.yaml -n leo
pod/web-app created
$ kubectl create -f web-app-service.yaml -n leo
service/web-app-service created
$ kubectl create -f mysql-pod.yaml -n leo
pod/mysql-db created
$ kubectl create -f mysql-service.yaml -n leo
service/mysql-service created
```

List all the objects in the namespace.

```
$ kubectl get all -n leo
NAME           READY   STATUS    RESTARTS   AGE
pod/mysql-db   1/1     Running   0          41s
pod/web-app    1/1     Running   0          76s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysql-service     ClusterIP   10.110.214.180   <none>        3306/TCP         23s
service/web-app-service   NodePort    10.104.154.79    <none>        3000:31003/TCP   60s
```

Get the IP address of the node. We'll use the IP address for the `curl` command. You can see in the output that there's an issue with the connecting to the database.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   147d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:31003
Failed to connect to database: ER_ACCESS_DENIED_ERROR: Access denied for user 'myuser'@'10.0.0.58' (using password: YES)
```

The MySQL Pod does not define a user named `myuser`. The only user that's available is the user named `root`. Therefore, we'll need to change the value of the environment variable `DB_USER` in the `web-app` Pod. Environment variables cannot be changed for a live object. Therefore, the Pod needs to be deleted and recreated.

```
$ kubectl delete pod web-app -n leo
pod "web-app" deleted
$ vim web-app-pod.yaml
...
spec:
  containers:
    ...
    env:
    ...
    - name: DB_USER
      value: root
...
$ kubectl create -f web-app-pod.yaml -n leo
pod/web-app created
$ curl 192.168.64.2:31003
Successfully connected to database!
```

Delete the namespace.

```
$ kubectl delete namespace leo
namespace "leo" deleted
```