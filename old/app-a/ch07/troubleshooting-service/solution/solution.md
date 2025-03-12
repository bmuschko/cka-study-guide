# Solution

Create the namespace `gemini` with the following command:

```
$ kubectl create namespace gemini
namespace/gemini created
```

Create all objects with the command `kubectl create -f <yaml-manifest> -n gemini`.

```
$ kubectl create -f web-app-pod.yaml -n gemini
pod/web-app created
$ kubectl create -f web-app-service.yaml -n gemini
service/web-app-service created
$ kubectl create -f mysql-pod.yaml -n gemini
pod/mysql-db created
$ kubectl create -f mysql-service.yaml -n gemini
service/mysql-service created
```

List all the objects in the namespace.

```
$ kubectl get all -n gemini
NAME           READY   STATUS    RESTARTS   AGE
pod/mysql-db   1/1     Running   0          66s
pod/web-app    1/1     Running   0          74s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysql-service     ClusterIP   10.96.250.63     <none>        3306/TCP         62s
service/web-app-service   NodePort    10.100.228.112   <none>        3000:32593/TCP   69s
```

Get the IP address of the node. We'll use the IP address for the `curl` command. You can see in the output that there's an issue with to the web application exposed by the Service `web-app-service`. The `curl` simply hangs.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   147d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:32593 -m 10
curl: (28) Connection timed out after 10004 milliseconds
```

Have a look at the details of the `web-app-service`. You will see that no endpoint is listed so something's wrong.

```
$ kubectl describe service/web-app-service -n gemini
Name:                     web-app-service
Namespace:                gemini
Labels:                   app=web-app-service
Annotations:              <none>
Selector:                 run=web-app
Type:                     NodePort
IP:                       10.100.228.112
Port:                     web-app-port  3000/TCP
TargetPort:               3000/TCP
NodePort:                 web-app-port  32593/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

Upon further inspection, you will find that the Service is using the label selector `run: web-app`, however, the assigned label to the Pod is `app: web-app`.

```
$ kubectl get service web-app-service -o yaml -n gemini | grep -C 1 selector:
    targetPort: 3000
  selector:
    run: web-app
$ kubectl get pod web-app -o yaml -n gemini | grep -C 1 labels:
  creationTimestamp: "2020-11-11T00:05:36Z"
  labels:
    app: web-app
```

Change the label selector by editing the live objects.

```
$ kubectl edit service web-app-service -n gemini
...
  selector:
    app: web-app
...
service/web-app-service edited
```

You can now connect to the web application via the Service.

```
$ curl 192.168.64.2:32593
Successfully connected to database!
```

Delete the namespace.

```
$ kubectl delete namespace gemini
namespace "gemini" deleted
```