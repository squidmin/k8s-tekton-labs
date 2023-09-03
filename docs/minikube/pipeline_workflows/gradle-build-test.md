# `gradle-build-test` pipeline workflow


## Prerequisites:
- <a href="https://github.com/squidmin/tekton-labs/blob/main/docs/auth/github_authentication.md">GitHub authentication</a>
- <a href="https://github.com/squidmin/tekton-labs/blob/main/docs/cluster_admin/installation_and_setup.md">Installation & setup</a>


### **1**: Apply secrets

<details>
<summary>Expand</summary>

```shell
kubectl apply -f Secrets/
```

Running the above command applies the following `Secret` configurations to the cluster:
- `ssh_secret.yaml`
- `serviceaccount.yaml`

**Output**

```
serviceaccount/build-bot created
secret/ssh-key created
```

</details>


### **2**: Apply tasks

<details>
<summary>Expand</summary>

```shell
kubectl apply -f Tasks/
```

Running the above command applies the following tasks to the cluster:
- `gradle-build.yaml`

**Output**

```
task.tekton.dev/build created
```

The `gradle-build` task is invoked in the pipeline:
- `Pipelines/gradle-build-test-pipeline.yaml`

</details>


### **3**: Apply pipelines

<details>
<summary>Expand</summary>

```shell
kubectl apply -f Pipelines/
```

**Output**

```
pipeline.tekton.dev/gradle-build-test created
```

</details>


### **4**: List tasks

<details>
<summary>Expand</summary>

```shell
kubectl get tasks
```

```shell
kubectl get tasks -n namespace
```

**Output**

```
NAME          AGE
build         2m37s
```

</details>


### **5**: Install the `git-clone` task

<details>
<summary>Expand</summary>

```shell
kubectl apply -f \
  https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.6/git-clone.yaml
```

</details>


### **6**: Create the `PipelineRun`

<details>
<summary>Expand</summary>

```shell
kubectl create -f PipelineRuns/gradle-build-spring-boot-cicd-pipeline-run.yaml
```

**Output**

```
pipelinerun.tekton.dev/gradle-build-run-t2m9p created
```

This creates a `PipelineRun` with a unique name each time.

Use the `PipelineRun` name from the output of the previous step to monitor the `Pipeline` execution:

```shell
tkn pipelinerun logs gradle-build-run-t2m9p -f
```

You may have to wait a few seconds. The output confirms that the repository was cloned successfully and displays the `README` file at the end.

</details>


### **7**: Show task status

<details>
<summary>Expand</summary>

If you've used the `kubectl apply` subcommand to apply a task to your cluster, you can show the task status via the `tkn` CLI:

```shell
tkn task describe gradle-build
tkn task start gradle-build --showlog
```

</details>


### **8**: Verify the `gradle-build` task of the `gradle-build-test` pipeline is working as expected

<details>
<summary>Expand</summary>

```shell
kubectl get taskrun gradle-build
```

</details>
