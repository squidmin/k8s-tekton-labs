# Using a Local Registry with Minikube


Read the GitHub gist <a href="https://gist.github.com/trisberg/37c97b6cc53def9a3e38be6143786589#install-a-local-registry">here</a>. 


## Install a local registry


<details>
<summary>Expand</summary>

### 1. Run the `registry:2` container

<details>
<summary>Expand</summary>

Use the `docker` CLI to run the `registry:2` container from Docker, listening on port `5000`, and persisting images in the `~/.registry/storage` directory.

```shell
docker run -d -p 5000:5000 --restart=always --volume ~/.registry/storage:/var/lib/registry registry:2
```

<img src="img/docker_run_registry_2.gif" width="">

</details>


### 2. Edit `/etc/hosts`

<details>
<summary>Expand</summary>

Edit the `/etc/hosts` file on your development machine, adding the name `registry.dev.svc.cluster.local` on the same line as the entry for `localhost`.

</details>


### 3. Validate that the registry is running.

<details>
<summary>Expand</summary>

```shell
docker ps
```

**Output**

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
02ea46d51f58        registry:2          "/entrypoint.sh /etc…"   About an hour ago   Up About a minute   0.0.0.0:5000->5000/tcp   sharp_pike
```

</details>


### 4. Validate that `registry.dev.svc.cluster.local:5000` is reachable

<details>
<summary>Expand</summary>

Validate that the registry at `registry.dev.svc.cluster.local:5000` is reachable from your development machine.

```shell
curl registry.dev.svc.cluster.local:5000/v2/_catalog
```

**Output**

```
{"repositories":[]}
```

</details>


### 5. Configure the docker daemon with an insecure registry

<details>
<summary>Expand</summary>

Configure the docker daemon with an insecure registry at `registry.dev.svc.cluster.local:5000`.
- macOS: `~/.docker/daemon.json`
- Linux: `/etc/docker/daemon.json`

Create the file if it does not exist.

```json
{
  "insecure-registries": ["registry.dev.svc.cluster.local:5000"]
}
```

</details>

</details>


---


## Start Minikube

<details>
<summary>Expand</summary>

```shell
minikube start --cpus 4 --memory 4096 --insecure-registry registry.dev.svc.cluster.local:5000
```

</details>


---


## Configure a fixed IP address

<details>
<summary>Expand</summary>

This IP address will allow processes in Minikube to reach the registry running on your host.
Configuring a fixed IP address avoids the problem of the IP address changing whenever you connect your machine to a different network.
If your machine already uses the `172.16.x.x` range for other purposes, choose an address in a different range e.g. `172.31.x.x.`.

```shell
export DEV_IP=172.16.1.1
```

Create an alias on macOS:

```shell
sudo ifconfig lo0 alias $DEV_IP
```

Create an alias on Linux:

```shell
sudo ifconfig lo:0 $DEV_IP
```

Note that the alias will need to be reestablished when you restart your machine.
This can be avoided by using a launchdeamon on macOS or by editing `/etc/network/interfaces` on Linux.

</details>


---


## Minikube `/etc/hosts`

<details>
<summary>Expand</summary>

Add an entry to `/etc/hosts` inside the minikube VM, pointing the registry to the IP address of the host.
This will result in `registry.dev.svc.cluster.local` resolving to the host machine allowing the docker daemon in minikube to pull images from the local registry.
This uses the `DEV_IP` environment variable from the previous step.

```shell
export DEV_IP=172.16.1.1
minikube ssh "echo \"$DEV_IP       registry.dev.svc.cluster.local\" | sudo tee -a  /etc/hosts"
```

</details>


---


## Kubernetes Service and Endpoint

<details>
<summary>Expand</summary>

Create a Kubernetes service without selectors called registry in the dev namespace and a Kubernetes endpoint with the same name pointing to the static IP address of your development machine.
This will result in `registry.dev.svc.cluster.local` resolving to the host machine, allowing container builds running in the cluster, to work with the local registry.

```shell
kubectl create namespace dev
```

```shell
cat <<EOF | kubectl apply -n dev -f -
---
kind: Service
apiVersion: v1
metadata:
  name: registry
spec:
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 5000
---
kind: Endpoints
apiVersion: v1
metadata:
  name: registry
subsets:
  - addresses:
      - ip: $DEV_IP
    ports:
      - port: 5000
EOF
```

</details>


---


## Relocate app images

<details>
<summary>Expand</summary>

Install irel CLI from https://github.com/pivotal/image-relocation/releases

For this example we are using a registry prefix of `registry.dev.svc.cluster.local:5000`; you would need to change this to match your registry (you also need to be authenticated with this registry).

To copy the time sink app to your own registry run:

```shell
irel copy springcloudstream/time-source-rabbit:2.1.2.RELEASE registry.dev.svc.cluster.local:5000/time-source-rabbit:2.1.2.RELEASE
```

To copy the log sink app to your own registry run:

```shell
irel copy springcloudstream/log-sink-rabbit:2.1.3.RELEASE registry.dev.svc.cluster.local:5000/log-sink-rabbit:2.1.3.RELEASE
```

You can now register the relocated apps using SCDF Shell:

```shell
dataflow:>app register --name time --type source --uri docker:registry.dev.svc.cluster.local:5000/time-source-rabbit:2.1.2.RELEASE
```

```shell
dataflow:>app register --name log --type sink --uri docker:registry.dev.svc.cluster.local:5000/log-sink-rabbit:2.1.3.RELEASE
```

</details>
