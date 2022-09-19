# Terraform, Git and Golang container image builder

## Why?

In order to execute Terraform scripts, and testing them using [Gruntworks Terratest](https://github.com/gruntwork-io/terratest), it is necessary to maintain a container image which contains both Golang, Git and Terraform.

- *Git* is necessary in order to clone repositories to the container image
- *Terraform* is necessary in order to execute the *Terraform* scripts
- *Golang* is necessary in order to execute the **Terratests**, made in *Go*

## How does this work?

### Overwriting arguements

The `build.sh` script file consist of a set of variables that overwrite the corresponding `ARG` variables defined in the `Dockerfile`. These are:

```sh
GOLANG_VERSION=
ALPINE_VERSION=
TERRAFORM_VERSION=
IMAGE_VERSION=
```

`GOLANG_VERSION` and `ALPINE_VERSION` is used to get the correct base image. `TERRAFORM_VERSION` is used to define which version of *Terraform* to download and expand into the container image. `IMAGE_VERSION` is used to tag the container image made from the `Dockerfile`.

In addition, there are two more arguements defined in the `Dockerfile` which can be overridden, but are currently not. These are:

- `USER_ID`: this defines the user id of the user we create so that the image does not run as *root*. Currently set to `1000`.
- `USER_NAME`: this defines the name of the user of the `USER_ID`. Currently set to `iac`.

### Selecting container manager

Since there are many competing container managers, where the two main competitors are *Docker* and *Podman*, the `build.sh` will only work if one of them exist. This is done by validating if `hash docker` errors. If so, it will use `podman` as container manager instead.

As an added benefit, the currently defined container manager will be outputted to the terminal window.

## How to execute the container image build

The `build.sh` script is executed by:

```sh
./build.sh
```

This will create a container image in the repository `localhost/tfgo-alpine` with the tag `0.1.0`.
