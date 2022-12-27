# oh-my-env

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/xbmlz/oh-my-env/release.yml?style=flat-square)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/xbmlz/oh-my-env?style=flat-square)

## What is oh-my-env?

oh-my-env is docker image for development environment.

## Features

- [ubuntu](https://ubuntu.com/) - Ubuntu is an open source software operating system that runs from the desktop, to the cloud, to all your internet connected things.

- [git](https://git-scm.com/) - Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

- [oh-my-zsh](https://ohmyz.sh/) - A delightful community-driven framework for [zsh](http://www.zsh.org/).
    - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - Fish-like autosuggestions for zsh.
    - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - Fish shell like syntax highlighting for Zsh.
    - [zsh-z](https://github.com/agkozak/zsh-z) - A smarter cd command for zsh.

- [node](https://nodejs.org/zh-cn/) - Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.
    - [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager - Simple bash script to manage multiple active node.js versions
    - [pnpm](https://pnpm.js.org/) - Fast, disk space efficient package manager

- [golang](https://go.dev/) - Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

- [rust](https://www.rust-lang.org/) - Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.

- [python](https://www.python.org/) - Python is an interpreted, high-level and general-purpose programming language.
    - [pyenv](https://github.com/pyenv/pyenv) - Simple Python version management
    - [poetry](https://python-poetry.org/) - Python dependency management and packaging made easy.

- [java](https://www.java.com/) - Java is a general-purpose programming language that is class-based, object-oriented, and designed to have as few implementation dependencies as possible.
    - [sdkman](https://sdkman.io/) - The Software Development Kit Manager
    - [maven](https://maven.apache.org/) - Apache Maven is a software project management and comprehension tool.
    - [gradle](https://gradle.org/) - Gradle is an open-source build automation tool focused on flexibility and performance.

## How to use?

1. create `.devcontainer` directory in your project root.

2. create `Dockerfile` in `.devcontainer` directory.

```Dockerfile
FROM xbmlz/on-my-env:latest
```

3. create `devcontainer.json` in `.devcontainer` directory.

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.194.0/containers/docker-existing-dockerfile
{
    "name": "OhMyEnv",
    "dockerFile": "Dockerfile",
    "context": "..",
    "extensions": [],
    "runArgs": [],
    "containerEnv": {},
    "mounts": [
        "source=config,target=/root/.config,type=volume",
        "source=vscode-extensions,target=/root/.vscode-server/extensions,type=volume",
        "source=ssh,target=/root/.ssh,type=volume",
        "source=go-bin,target=/root/go/bin,type=volume",
        "source=pnpm-bin,target=/root/.local/share/pnpm,type=volume",
        "source=gradle-cache,target=/root/.gradle,type=volume",
        "source=maven-cache,target=/root/.m2,type=volume"
    ],
    "remoteUser": "root"
}
```

4. open your project in vscode.

5. install `Remote - Containers` extension.

6. click `Remote-Containers: Reopen in Container` in command palette.

7. enjoy it.

> if you use IntelliJ IDEA, you can use plugin [Docker Integration](https://plugins.jetbrains.com/plugin/7724-docker-integration) to open your project in docker container.

## License

[MIT](LICENSE)