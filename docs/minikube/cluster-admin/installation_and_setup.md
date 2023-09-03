# Installation and setup


### **1**: `minikube` installation

<details>
<summary>Expand</summary>

```shell
brew install minikube
```

For other installation options, refer to: https://minikube.sigs.k8s.io/docs/start/

</details>


### **2**: Install the Tekton CLI to your machine

<details>
<summary>Expand</summary>

```shell
brew install tektoncd-cli
```

More info: https://tekton.dev/docs/cli/#installation

</details>


### **3**: Create a cluster

<details>
<summary>Expand</summary>

Start a cluster with 2 CPUs and 2 GB of memory:

```shell
minikube start --kubernetes-version v1.24.4
```

There are options available to choose a different driver than the default (`docker`). For example:

```shell
minikube start \
  --kubernetes-version v1.24.4 \
  --driver qemu \
  --network socket_vmnet
```

### Set memory and CPU

By default, `minikube` starts a cluster with 2 CPUs and 2 GB of memory. More CPUs and memory can be added:

```shell
minikube start \
  --memory 4068 \
  --cpus 4 \
  --kubernetes-version v1.24.4
```

### Mount a local directory to the cluster

```shell
export LOCAL_SOURCE_PATH="$HOME/path/to/local/source"
minikube start \
  --memory 4068 \
  --cpus 4 \
  --kubernetes-version v1.24.4 \
  --mount-string="${LOCAL_SOURCE_PATH}:/data" --mount
```

<img src="img/minikube_start_cmd.gif">

</details>


### **4**: Check that the cluster was successfully created using `kubectl`

<details>
<summary>Expand</summary>

```shell
kubectl cluster-info
```

<!-- <img src="img/kubectl_cluster_info_cmd.gif" width="600px"> -->

</details>


### **5**: Install Tekton pipelines

<details>
<summary>Expand</summary>

1. Install the latest version of Tekton pipelines

     ```shell
     kubectl apply --filename \
       https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
     ```

     <!-- <img src="img/install_tekton_pipelines_latest_version.gif" width="600px"> -->

2. Monitor the installation

     ```shell
     kubectl get pods --namespace tekton-pipelines --watch
     ```

     <img src="img/kubectl_get_pods_cmd.gif" width="600px">

     When both `tekton-pipelines-controller` and `tekton-pipelines-webhook` show `1/1` under the `READY` column, you are ready to continue. For example:

     ```shell
     NAME                                           READY    STATUS               RESTARTS     AGE
     tekton-pipelines-controller-6d989cc968-j57cs   0/1      Pending              0            3s
     tekton-pipelines-webhook-69744499d9-t58s5      0/1      ContainerCreating    0            3s
     tekton-pipelines-controller-6d989cc968-j57cs   0/1      ContainerCreating    0            3s
     tekton-pipelines-controller-6d989cc968-j57cs   0/1      Running              0            5s
     tekton-pipelines-webhook-69744499d9-t58s5      0/1      Running              0            6s
     tekton-pipelines-controller-6d989cc968-j57cs   1/1      Running              0            10s
     tekton-pipelines-webhook-69744499d9-t58s5      1/1      Running              0            20s
     ```

  Hit _Ctrl + C_ to stop monitoring.

</details>
