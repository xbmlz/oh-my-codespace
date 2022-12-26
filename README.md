# oh-my-env

[![Build Status](https://travis-ci.org/oh-my-env/oh-my-env.svg?branch=master)](https://travis-ci.org/oh-my-env/oh-my-env)

## What is oh-my-env?

oh-my-env is docker image for development environment.

## Features

- [x] [oh-my-zsh](https://ohmyz.sh/) - A delightful community-driven framework for [zsh](http://www.zsh.org/).
- [x] [nvm](https://github.com/nvm-sh/nvm) - Node Version Manager - Simple bash script to manage multiple active node.js versions
- [x] [pnpm](https://pnpm.js.org/) - Fast, disk space efficient package manager
- [x] [golang](https://go.dev/) - Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.
- [x] [rust](https://www.rust-lang.org/) - Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.
- [x] [pyenv](https://github.com/pyenv/pyenv) - Simple Python version management

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
    "name": "Oh My Env",
    "dockerFile": "Dockerfile",
    "context": "..",
    "settings": {
        "terminal.integrated.shell.linux": "/bin/zsh"
    },
    "extensions": [],
    "runArgs": [
        "--network=omenet",
    ],
    "containerEnv": {
        "DISPLAY": "host.docker.internal:0.0"
    },
    "mounts": [
        "source=config,target=/root/.config,type=volume",
        "source=vscode-extensions,target=/root/.vscode-server/extensions,type=volume",
        "source=ssh,target=/root/.ssh,type=volume",
        "source=go-bin,target=/root/go/bin,type=volume",
        "source=pnpm-bin,target=/root/.local/share/pnpm,type=volume"
    ],
    "remoteUser": "root"
}
```

4. open your project in vscode.

5. click `Remote-Containers: Reopen in Container` in command palette.

## License

[MIT](LICENSE)