#!/bin/bash

# Install the Tekton components to the cluster:

kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
#kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.4/git-clone.yaml
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/kaniko/0.6/raw

kubectl apply -f crds/PersistentVolumeClaims/
kubectl apply -f cdrs/Secrets/
kubectl apply -f cdrs/Tasks/
kubectl apply -f cdrs/Pipelines/
