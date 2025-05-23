#!/usr/bin/env bash
set -e
set -o pipefail

k3d cluster delete qa
k3d cluster delete staging
k3d cluster delete prod
k3d cluster delete admin