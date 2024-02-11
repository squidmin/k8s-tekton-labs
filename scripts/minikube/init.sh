#!/bin/bash

# init.sh
# Initializes minikube and installs Tekton pipelines.

LOCAL_SOURCE_PATH="$1"

#minikube start --kubernetes-version v1.24.4
/usr/local/bin/minikube start \
  --cpus 4 \
  --kubernetes-version v1.24.4 \
  --mount-string="${LOCAL_SOURCE_PATH}:/local_source" -- mount

/usr/local/bin/kubectl cluster-info

/usr/local/bin/kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
/usr/local/bin/kubectl get pods --namespace tekton-pipelines --watch
