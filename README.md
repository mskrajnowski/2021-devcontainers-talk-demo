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
