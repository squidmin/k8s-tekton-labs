#!/bin/bash

# apply.sh
# Installs pipeline dependencies & custom resource definitions (CRDs).

# Install the Tekton components to the cluster:
/usr/local/bin/kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
#/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.4/git-clone.yaml
/usr/local/bin/kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/kaniko/0.6/raw

# Install the Custom Resource Definitions (CRDs):
/usr/local/bin/kubectl apply -f crds/PersistentVolumeClaims/
/usr/local/bin/kubectl apply -f crds/ServiceAccounts/
/usr/local/bin/kubectl apply -f cdrs/Secrets/
/usr/local/bin/kubectl apply -f cdrs/Tasks/
/usr/local/bin/kubectl apply -f cdrs/Pipelines/
