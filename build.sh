#!/bin/sh

set -e

# Define overwrites for Dockerfile ARGs
GOLANG_VERSION="1.19" # By defining 1.19, you get the latest build version of Golang inside 1.19 (currently 1.19.3)
TERRAFORM_VERSION="1.3.5"    # By not defining TERRAFORM_VERSION, you get the latest version available.
IMAGE_VERSION="0.1.0"

# Define TERRAFORM_VERSION to latest version, if not defined above.
if [ -z $TERRAFORM_VERSION ]; then
  TERRAFORM_VERSION=$(curl -sL https://releases.hashicorp.com/terraform | xmllint --html --xpath "//@href" - | grep -o "/[1-9][0-9]\?\.[0-9]+\?\.[0-9]+\?/" | head -n 1 | cut -d '/' -f2)
fi

# Set the container manager to docker or podman,
# depending on whether or not docker exists.
if hash docker 2>/dev/null; then
  CONTAINER_MANAGER=docker
else
  CONTAINER_MANAGER=podman
fi

# Echo back to the terminal which container manager will be used.
echo "The container manager that will be used is: $CONTAINER_MANAGER"

# The container image building script
${CONTAINER_MANAGER} build --layers --force-rm \
  --build-arg GOLANG_VERSION=$GOLANG_VERSION \
  --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION \
  --tag tfgo-alpine:$IMAGE_VERSION .
