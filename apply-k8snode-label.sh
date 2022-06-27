#!/bin/bash

# this script is used to apply a label to all nodes in a Kubernetes cluster
# you must already be auth'd to the kuberenetes cluster before running the script

# usage: sh ./apply-k8snode-label.sh <label>

# https://cloud.google.com/kubernetes-engine/docs/how-to/creating-managing-labels#gcloud_1
# https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/#add-a-label-to-a-node

# check is a label is passed in and exit if not
# this script does not check if the label is valid or already applied
if [[ $# -eq 0 ]] ; then
    echo 'No label provided'
    echo 'Usage: sh ./apply-k8snode-label.sh <label>'
    exit 1
fi

# get just the column of node names from 'get nodes' output
NODES=$(kubectl get nodes | awk '{print $1}' | tail -n +2)

echo
echo "Applying label \"$1\" to all nodes in the cluster..."
echo

for endpoint in $NODES
do
    NODE_NAME=$endpoint
    kubectl label nodes $endpoint $1
    echo "label \"$1\" applied to node $endpoint"
    sleep 1
done