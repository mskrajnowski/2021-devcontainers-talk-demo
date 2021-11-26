# devcontainers-demo

A small app to demonstrate developing an application using containers with docker and docker-compose to limit the amount of tools needed on the host operating system.

The app consists of:

- [./web](./app) - Frontend single-page app
- [./backend](./api) - Backend service that provides data for the frontend
- [./infrastructure](./infrastructure) - Terraform configuration required to deploy the backend to Heroku and the web client to S3 and CloudFront

The backend uses redis for storage and pub/sub.

## Setup

1. Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. Install [docker](https://docs.docker.com/get-docker/)
3. Install [docker-compose](https://docs.docker.com/compose/install/)
4. Run the entire stack locally with `docker-compose`

   ```sh
   docker-compose up
   ```

## Customization

> TODO: fixing filesystem permision issues

> TODO: custom shell

> TODO: dotfiles

## Deployment

> TODO: Setting up Heroku credentials

> TODO: Setting up AWS credentials

> TODO: Deployment instructions

## Notes

### How was the web app bootstrapped

The web app is based on create-react-app. If we don't have node or npm on the host system, we can't run `npx create-react-app`.

In order to get things going, we need to run `npx` in a container as well, with the project directory mounted as a volume.

```sh
docker run \
    --rm \
    --user "$(id -u):$(id -g)" \
    --volume "$PWD:/opt/devcontainers-demo" \
    --workdir /opt/devcontainers-demo \
    node:16.13.0-bullseye-slim \
    npx create-react-app web --template typescript --use-npm
```

Let's break this down:

- `docker run ... node npx ...` - pull the `node` container image and run `npx` inside a `node` container
- `--rm` - remove the container when the run exits
- `--user "$(id -u):$(id -g)"` - run with the same user id and group id as the host user to ensure the created code is owned by the host user
- `--volume "$PWD:/opt/devcontainers-demo"` - mount the project directory (current working directory) to `/opt/devcontainers-demo` in the container file system
- `--workdir /opt/devcontainers-demo` run the command (`npx`) from the mounted project directory
- `node:16.13.0-bullseye-slim` - use node.js 16.13.0 image based on [debian bullseye](https://www.debian.org/releases/bullseye/) in the slim variant, which should only include the necessary debian packages
- `npx create-react-app ...` - run `npx create-react-app` with the given arguments inside the node.js container

> **MacOS and Windows**
>
> MacOS and Windows users should use `--user node` instead. Docker is run inside a Linux VM on non-Linux operating systems, so there shouldn't be any file system permission issues as the VM hypervisor should ensure the right permissions are set. `--user node` is a good practice to ensure the image is not being run as `root` in the Linux VM.
