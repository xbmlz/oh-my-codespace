FROM archlinux:base

WORKDIR /tmp

# Change pacman source
ADD mirrorlist /etc/pacman.d/mirrorlist
RUN yes | pacman -Syu
RUN yes | pacman -S git which vim curl tree htop zsh

# Init config dir
RUN mkdir -p /root/.config

# Install oh-my-zsh
RUN curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash \
    && git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 \
    && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

# Install nvm and set default node
ARG NODE_VERSION=18
ENV PNPM_HOME /root/.local/share/pnpm
ENV PATH $PNPM_HOME:$PATH
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . /root/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && npm install -g pnpm

# Install Go
ENV GOPATH /root/go
ENV PATH $GOPATH/bin:$PATH
ENV GOROOT /usr/lib/go
RUN yes | pacman -S go \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH" \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct

# Install pyenv and set default python
ARG PYTHON_VERSION=3.9.7
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
RUN yes | pacman -S --needed base-devel openssl zlib xz tk
RUN curl https://pyenv.run | bash \
    && eval "$(pyenv init -)" \
    && eval "$(pyenv virtualenv-init -)" \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION

# Install rust
ADD .cargo.cn.config /root/.cargo/config
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
ENV CARGO_HTTP_MULTIPLEXING=false
ENV CARGO_HOME=/root/.cargo
ENV PATH $CARGO_HOME/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Finsih config
ADD .zshrc /root/.zshrc
RUN chsh -s /bin/zsh
RUN yes | pacman -Scc

WORKDIR /home