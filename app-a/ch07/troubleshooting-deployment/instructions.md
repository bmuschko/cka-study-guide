In this exercise, you will troubleshoot a misconfigured applications. The web application managed by a Deployment controls 4 replicas. The Pods have been exposed by a Service. The Service for the web application Pod is of type `NodePort`.

The following image shows the high-level architecture.

![app-architecture](imgs/app-architecture.png)

1. Create a new namespace named `pisces`.
2. Within the namespace, create the following objects in the given order from the YAML files: `pisces/web-app-service.yaml`, `pisces/web-app-deployment.yaml`. The Pod running web application exposes the container port 3000. From your machine, execute `curl` or `wget` to access the application through the Service endpoint from outside of the cluster. A successful response should render `Hello World`. Identify the underlying issue and fix it.
3. The `curl` or `wget` command should now render the message `Hello World`.
4. Delete the namespace `pisces`.