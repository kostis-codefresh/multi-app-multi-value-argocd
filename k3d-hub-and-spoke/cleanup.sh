#!/usr/bin/env bash
set -e
set -o pipefail

k3d cluster delete qa-eu
k3d cluster delete qa-us
k3d cluster delete staging
k3d cluster delete prod-eu
k3d cluster delete prod-eu
k3d cluster delete prod-eu
k3d cluster delete admin