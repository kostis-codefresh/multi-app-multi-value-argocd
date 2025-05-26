#!/usr/bin/env bash
set -e
set -o pipefail

source clusters.sh
source argocd.sh

# make sure we have the proper binaries on our path and arent using a scary kubectx
precheck

# create the clusters. the order matters here because of core dns entries
# we want the "central" cluster to be created last so it can target all the "workload" clusters
createCluster "qa-us"
createCluster "qa-eu"
createCluster "staging"
createCluster "prod-us"
createCluster "prod-eu"
createCluster "prod-asia"
createCluster "admin"

namespace=argocd
port=8080

# order of the above clusters matter
# TODO: switch to the admin kubeconfig
deployArgoCD "$namespace" "$port"
addClustersToArgoCD

echo "Setting labels on clusters..."

argocd login localhost:8080 --username admin --password admin1234 --insecure 
argocd cluster set qa-us --label "type=workload" --label "cloud=gcp" --label "env=qa" --label "region=us"
argocd cluster set qa-eu --label "type=workload" --label "cloud=gcp" --label "env=qa" --label "region=eu"
argocd cluster set staging --label "type=workload" --label "cloud=gcp" --label "env=staging" --label "env=staging" --label "region=us"
argocd cluster set prod-us --label "type=workload" --label "cloud=aws" --label "env=prod" --label "env=prod" --label "region=us"
argocd cluster set prod-eu --label "type=workload" --label "cloud=aws" --label "env=prod" --label "env=prod" --label "region=eu"
argocd cluster set prod-asia --label "type=workload" --label "cloud=aws" --label "env=prod" --label "env=prod" --label "region=asia"
argocd cluster set admin --label "type=hub" --label "cloud=aws"