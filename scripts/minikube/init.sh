#!/bin/bash

LOCAL_SOURCE_PATH="$1"

#minikube start --kubernetes-version v1.24.4
minikube start \
  --cpus 4 \
  --kubernetes-version v1.24.4 \
  --mount-string="${LOCAL_SOURCE_PATH}:/local_source" -- mount

kubectl cluster-info

kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl get pods --namespace tekton-pipelines --watch
