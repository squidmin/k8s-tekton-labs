# `kubectl` cli reference


### Verify that a `Task` is working as expected

<details>
<summary>Expand</summary>

Create a `TaskRun` to run the `Task`, then run it using:

```shell
kubectl create --filename TaskRuns/example-task-run.yaml
```

Assuming the `TaskRun` you create is named `example-task-run`, you can view the status of the `TaskRun` using:

```shell
kubectl get taskrun example-task-run
```

Add the `-w` option to run the above command in watch mode.

To view the `TaskRun`'s logs, run:

```shell
tkn taskrun logs task-run-xxxxx -f
```

</details>


### Apply changes to a `Task`

<details>
<summary>Expand</summary>

If changes are made to one of the `Task` files, you can apply the changes to your cluster using:

```shell
kubectl apply --filename Tasks/filename.yaml
```

</details>


### _View the logs of a specific `PipelineRun`_

<details>
<summary>Expand</summary>

```shell
tkn pipelinerun logs example-pipelinerun-xxxxx -f
```

e.g.,

```shell
tkn pipelinerun logs build-and-push-pipelinerun-pjd48 -f
```

</details>


### Delete a `Pipeline`

<details>
<summary>Expand</summary>

```shell

```

</details>


### Delete a `PipelineRun`

<details>
<summary>Expand</summary>

```shell

```

</details>


### View the status of a `PipelineRun`

<details>
<summary>Expand</summary>

```shell
kubectl get pipelinerun example-pipeline-run
```

```shell
kubectl get pipelinerun example-pipeline-run-bdpt6 -o=jsonpath='{.status.conditions[*].message}'
```

Add the `-w` option to run the above command in watch mode.

</details>


### Monitor all `PipelineRun`s

<details>
<summary>Expand</summary>

```shell
kubectl get pipelineruns -w
```

</details>


### Apply changes to a `Pipeline`

<details>
<summary>Expand</summary>

```shell
kubectl apply --filename Pipelines/filename.yaml
```

</details>


### Delete and re-create a `PersistentVolumeClaim` (PVC)

<details>
<summary>Expand</summary>

```shell
kubectl delete pvc <pvc-name>
kubectl apply -f <pvc-definition.yaml>
```

e.g.,

```shell
kubectl delete pvc source-pvc
kubectl apply -f crds/PersistentVolumeClaims/pvc.yaml
```

</details>
