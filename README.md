# oh-my-env

[![Build Status](https://travis-ci.org/oh-my-env/oh-my-env.svg?branch=master)](https://travis-ci.org/oh-my-env/oh-my-env)

## What is oh-my-env?

oh-my-env is docker image for development environment.

## How to use?

### 1. Install docker

### 2. Pull image

```bash
$ docker pull xbmlz/oh-my-env
```

### 3. Run container

```bash
$ docker run -it xbmlz/oh-my-env /bin/zsh
```

### Vscode Remote Development

#### 1. Install vscode

#### 2. Install Remote Development extension

#### 3. Open folder in container

## How to build?

```bash

$ docker build -t oh-my-env .

```

## How to publish image?

```bash

$ docker login

$ docker tag oh-my-env:latest xbmlz/oh-my-env:latest

$ docker push xbmlz/oh-my-env:latest

```

## License

[MIT](LICENSE)