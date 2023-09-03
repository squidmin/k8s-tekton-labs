# minikube CLI reference

### Set the `LOCAL_SOURCE_PATH` environment variable

<details>
<summary>Expand</summary>

```shell
export LOCAL_SOURCE_PATH="$HOME/path/to/the/project"
```

</details>


### Start the `minikube` cluster

<details>
<summary>Expand</summary>

```shell
minikube start \
  --cpus 4 \
  --kubernetes-version v1.24.4 \
  --mount-string="${LOCAL_SOURCE_PATH}:/local_source" -- mount
```

</details>


### Interact with a cluster

<details>
<summary>Display cluster info</summary>

```shell
kubectl get go -A
```

</details>


<details>
<summary>Access the Kubernetes dashboard</summary>

```shell
minikube dashboard
```

</details>


<details>
<summary>Point your shell to minikube's docker-daemon</summary>

```shell
eval $(minikube -p minikube docker-env)
```

</details>


---


### Deploy a service

<details>
<summary>Create a simple deployment and expose it on port 8080</summary>

```shell
kubectl create deployment example-application --image=localhost/example-application:latest
kubectl expose deployment example-application --type=NodePort --port=8080
```

It may take a moment, but your deployment will soon show up when you run:

```shell
kubectl get services example-application
```

</details>


<details>
<summary>Access the service</summary>

```shell
minikube service example-application
```

</details>


<details>
<summary>Forward the application port</summary>

```shell
kubectl port-forward service/example-application 7080:8080
```

</details>


### Clean up resources created in cluster

<details>
<summary>Expand</summary>

```shell
kubectl delete service example-application
kubectl delete deployment example-application
```

</details>


### Delete a pod

<details>
<summary>Expand</summary>

```shell
kubectl delete pod POD_NAME
```

```shell
kubectl delete -n default pod POD_NAME
```

**Examples**:

```shell
kubectl delete pod example-application-d5g09c875-sqioy
```

```shell
kubectl delete -n default pod example-application-d5g09c875-sqioy
```

</details>


---


### Manage your cluster

<details>
<summary>Pause Kubernetes without impacting deployed applications</summary>

```shell
minikube pause
```

</details>

<details>
<summary>Unpause a paused instance</summary>

```shell
minikube unpause
```

</details>

<details>
<summary>Halt the cluster</summary>

```shell
minikube stop
```

</details>

<details>
<summary>Change the default memory limit (requires a restart)</summary>

```shell
minikube config set memory 9001
```

</details>

<details>
<summary>Browse the catalog of easily installed Kubernetes services</summary>

```shell
minikube addons list
```

</details>

<details>
<summary>Create a second cluster running an older Kubernetes release</summary>

```shell
minikube start -p aged --kubernetes-version=v1.16.1
```

</details>

<details>
<summary>Delete all of the minikube clusters</summary>

```shell
minikube delete --all
```

</details>
