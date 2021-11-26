# Prepare an image for testing, building and deploying the application.
# Use node.js 16.13.0 in a debian bullseye container.
FROM node:16.13.0-bullseye-slim as builder

# Change the node user's id and group id to match the host user's
ARG UID=1000
ARG GID=1000
RUN usermod -u ${UID} node \
  && groupmod -g ${GID} node \
  && chown -R node:node /home/node

# Create the /opt/devcontainers-demo directory and set the owner to the node user
RUN mkdir -p /opt/devcontainers-demo/web \
  && chown -R node:node /opt/devcontainers-demo

WORKDIR /opt/devcontainers-demo/web

# Install packages needed for installing tools
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  unzip

# Install AWS CLI needed for deployment
ENV AWS_CLI_VERSION=2.3.7
ENV AWS_CLI_SHA256=d470ebd56dad6f6e2c410526f91518d40a3adebb0402833d71f80e955c98945b

RUN curl -o aws_cli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
  && echo "${AWS_CLI_SHA256} aws_cli.zip" | sha256sum --check \
  && unzip aws_cli.zip \
  && ./aws/install \
  && rm -r aws_cli.zip aws

USER node

# Install production & dev dependencies
COPY ./package.json ./package-lock.json ./
RUN npm ci --no-audit

# Copy the source code
COPY ./ ./

# Set the build script as the default command
CMD npm run build

# Prepare an image for developing the application, based on the builder image
FROM builder as dev

USER root
RUN test -f docker.local.sh && bash docker.local.sh
USER node

CMD npm run start
