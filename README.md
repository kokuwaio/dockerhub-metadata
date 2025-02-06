# Dockerhub Metadata Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/dockerhub-metadata)](https://hub.docker.com/repository/docker/kokuwaio/dockerhub-metadata)
[![size](https://img.shields.io/docker/image-size/kokuwaio/dockerhub-metadata)](https://hub.docker.com/repository/docker/kokuwaio/dockerhub-metadata)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://github.com/kokuwaio/dockerhub-metadata/blob/main/Dockerfile)
[![license](https://img.shields.io/github/license/kokuwaio/dockerhub-metadata)](https://github.com/kokuwaio/dockerhub-metadata/blob/main/LICENSE)
[![issues](https://img.shields.io/github/issues/kokuwaio/dockerhub-metadata)](https://github.com/kokuwaio/dockerhub-metadata/issues)

A [Woodpecker CI](https://woodpecker-ci.org) plugin to write metadata to DockerHub repositories.  
Also usable with Gitlab, Github or locally, see examples for usage.

## Features

- set full description in repository from local file
- set short description in repository from settings
- set categories for repository

## Example

Woodpecker:

```yaml
steps:
  dockerhub:
    image: kokuwaio/dockerhub-metadata
    depends_on: []
    settings:
      repository: kokuwaio/example-image
      description-short: This image does that!
      categories: [developer-tools, integration-and-delivery]
      username: {from_secret: DOCKERHUB_USERNAME}
      password: {from_secret: DOCKERHUB_PASSWORD}
    when:
      event: push
      branch: main
      path: README.md
```

Gitlab:

```yaml
dockerhub:
  stage: deploy
  needs: []
  image: kokuwaio/hadolint
  variables:
    PLUGIN_REPOSITORY: kokuwaio/example-image
    PLUGIN_DESCRIPTION_SHORT: This image does that!
    PLUGIN_CATEGORIES: developer-tools,integration-and-delivery
  rules:
    - if: $CI_PIPELINE_SOURCE == "push"
      changes: [README.md]
```

## Settings

| Settings Name       | Environment              | Default     | Description                                                 |
| ------------------- | ------------------------ | ----------- | ----------------------------------------------------------- |
| `repository`        | PLUGIN_REPOSITORY        | `none`      | Repository to update with metadata, e.g. `kokuwaio/example` |
| `description-short` | PLUGIN_DESCRIPTION_SHORT | `none`      | Short description for repository.                           |
| `description-file`  | PLUGIN_DESCRIPTION_FILE  | `README.md` | File to read full description from                          |
| `categories`        | PLUGIN_CATEGORIES        | `[]`        | List of categories to set (maximum 3)                       |
| `username`          | PLUGIN_USERNAME          | `none`      | Username for Dockerhub login                                |
| `password`          | PLUGIN_PASSWORD          | `none`      | Password for Dockerhub login, **PAT** is not supported!     |
