# DockerHub Metadata WoodpeckerCI Plugin

[![pulls](https://img.shields.io/docker/pulls/kokuwaio/dockerhub-metadata)](https://hub.docker.com/r/kokuwaio/dockerhub-metadata)
[![size](https://img.shields.io/docker/image-size/kokuwaio/dockerhub-metadata)](https://hub.docker.com/r/kokuwaio/dockerhub-metadata)
[![dockerfile](https://img.shields.io/badge/source-Dockerfile%20-blue)](https://git.kokuwa.io/woodpecker/dockerhub-metadata/src/branch/main/Dockerfile)
[![license](https://img.shields.io/badge/License-EUPL%201.2-blue)](https://git.kokuwa.io/woodpecker/dockerhub-metadata/src/branch/main/LICENSE)
[![prs](https://img.shields.io/gitea/pull-requests/open/woodpecker/dockerhub-metadata?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/dockerhub-metadata/pulls)
[![issues](https://img.shields.io/gitea/issues/open/woodpecker/dockerhub-metadata?gitea_url=https%3A%2F%2Fgit.kokuwa.io)](https://git.kokuwa.io/woodpecker/dockerhub-metadata/issues)

A [WoodpeckerCI](https://woodpecker-ci.org) plugin to write metadata to DockerHub repositories.  
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
