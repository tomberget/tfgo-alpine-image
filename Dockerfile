# Define default arguments for the base image
ARG GOLANG_VERSION

FROM golang:"$GOLANG_VERSION"-alpine

# Define default arguments for the run sections below
ARG USER_ID="1000" USER_NAME="iac"
ARG TERRAFORM_VERSION

# Add a default user with name from the USER_NAME argument and id from the USER_ID arguement.
# Also, update APK, and install git, curl and unzip.
# Finally, download, extract and move the terraform binary, and remove the archived file
RUN adduser -g IAC User -s /bin/sh -u "$USER_ID" -D "$USER_NAME" \
    && apk add git~=2 curl~=7 --no-cache \
    && curl -sL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && mv ./terraform /usr/bin

# Set the container userid
USER $USER_ID

# Define work directory to users home
WORKDIR /home/$USER_NAME

ENTRYPOINT [ "/bin/sh", "-c" ]
