# Prepare an image for testing, building and deploying the infrastructure.
FROM debian:bullseye-slim as builder

# Create dev user
ARG UID=1000
ARG GID=1000
RUN groupadd --gid ${GID} dev
RUN useradd \
  --uid ${UID} \
  --gid ${GID} \
  --shell "/usr/bin/bash" \
  --create-home \
  dev

# Create the /opt/devcontainers-demo directory and set the owner to the dev user
RUN mkdir -p /opt/devcontainers-demo/infrastructure \
  && chown -R dev:dev /opt/devcontainers-demo

WORKDIR /opt/devcontainers-demo/infrastructure

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  unzip \
  git

# Install terraform
ENV TERRAFORM_VERSION=1.0.11
ENV TERRAFORM_SHA256=eeb46091a42dc303c3a3c300640c7774ab25cbee5083dafa5fd83b54c8aca664

RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && echo "${TERRAFORM_SHA256} terraform.zip" | sha256sum --check \
  && unzip terraform.zip \
  && chmod +x terraform \
  && mv terraform /usr/bin/ \
  && rm terraform.zip

# Install AWS CLI
ENV AWS_CLI_VERSION=2.3.7
ENV AWS_CLI_SHA256=d470ebd56dad6f6e2c410526f91518d40a3adebb0402833d71f80e955c98945b

RUN curl -o aws_cli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
  && echo "${AWS_CLI_SHA256} aws_cli.zip" | sha256sum --check \
  && unzip aws_cli.zip \
  && ./aws/install \
  && rm -r aws_cli.zip aws

COPY ./versions.tf ./providers.tf ./.terraform.lock.hcl ./
RUN terraform init -input=false -lockfile=readonly -backend=false

COPY ./ ./

USER dev
CMD bash

# Prepare an image for developing the application, based on the builder image
FROM builder as dev
