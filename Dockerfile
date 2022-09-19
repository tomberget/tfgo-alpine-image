# Define default arguments for the base image
ARG GOLANG_VERSION="1.19" ALPINE_VERSION="3.15"

FROM golang:"$GOLANG_VERSION"-alpine"$ALPINE_VERSION"

# Define default arguments for the run sections below
ARG TERRAFORM_VERSION="1.2.8"
ARG USER_ID="1000"
ARG USER_NAME="iac"

# Add a default user with name from the USER_NAME argument and id from the USER_ID arguement.
RUN adduser -g "IAC User" -s "/bin/sh" -u $USER_ID -D $USER_NAME

# Update APK, and install git, curl and unzip
RUN apk update \
  && apk add git curl unzip

# Download, extract and install terraform, using the ARG version from above
RUN curl -sL https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip -o terraform_"$TERRAFORM_VERSION"_linux_amd64.zip \
  && unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip \
  && rm terraform_"$TERRAFORM_VERSION"_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && terraform -version \
  && go version

# Set the container userid
USER $USER_ID

WORKDIR /home/$USER_NAME