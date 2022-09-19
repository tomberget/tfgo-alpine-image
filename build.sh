#!/bin/sh

set -e

# Define overwrites for Dockerfile ARGs
GOLANG_VERSION="1.19.1"
ALPINE_VERSION="3.16"
TERRAFORM_VERSION="1.2.9"
IMAGE_VERSION="0.1.0"

# Set the container manager to docker or podman,
# depending on whether or not docker exists.
if hash docker 2>/dev/null; then
  CONTAINER_MANAGER=docker
else
  CONTAINER_MANAGER=podman
fi

# Echo back to the terminal which container manager will be used.
echo "The container manager that will be used is: "$CONTAINER_MANAGER

# The container image building script
${CONTAINER_MANAGER} build --layers --force-rm \
  --build-arg GOLANG_VERSION=$GOLANG_VERSION \
  --build-arg ALPINE_VERSION=$ALPINE_VERSION  \
  --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION \
  --tag tfgo-alpine:$IMAGE_VERSION .