FROM ubuntu:latest

# Change apt source
ADD sources.list /etc/apt/sources.list

# Update apt
RUN apt update && apt upgrade -y

# Install bascic tools
RUN apt install -y curl wget git vim zsh zip unzip sed

# Init config dir
RUN mkdir -p /root/.config
VOLUME [ "/root/.config", "/root/.vscode-server/extensions", "/root/.local/share/pnpm", "/root/go/bin", "/root/.ssh" ]

# Install oh-my-zsh
ARG ZSH_CUSTOM=/root/.oh-my-zsh/custom
RUN git clone https://gitee.com/mirrors/ohmyzsh.git ~/.oh-my-zsh \
    && git clone https://gitee.com/github-mirror-zsh/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 \
    && ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" \
    && git clone https://gitee.com/xbmlz/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://gitee.com/xbmlz/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://gitee.com/xbmlz/zsh-z.git $ZSH_CUSTOM/plugins/zsh-z

# Install nvm and default node
ARG NVM_DIR=/root/.nvm \
    && NODE_VERSION=v16
RUN curl -o- https://gitee.com/mirrors/nvm/raw/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g pnpm \
    && pnpm config set store-dir /root/.local/share/pnpm

# Install Go
ARG GOPATH /root/go \
    && GO_VERSION=1.18.9 
RUN wget https://studygolang.com/dl/golang/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /root -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && mkdir -p $GOPATH/src $GOPATH/bin \
    && export PATH=$PATH:/root/go/bin \
    && go env -w GOPROXY=https://goproxy.cn,direct

# Install pyenv
ARG PYENV_ROOT=/root/.pyenv \
    && PYTHON_VERSION=3.9.7
ENV PYTHON_BUILD_MIRROR_URL=https://npm.taobao.org/mirrors/python
ADD pyenv-installer.sh /tmp/pyenv-installer.sh
RUN bash /tmp/pyenv-installer.sh \
    && export PATH="$PYENV_ROOT/bin:$PATH" \
    && eval "$(pyenv init -)" \
    && eval "$(pyenv virtualenv-init -)" \
    && apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install rust
ADD .cargo.cn.config /root/.cargo/config
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
ENV CARGO_HTTP_MULTIPLEXING=false
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Change default shell
ADD .zshrc /root/.zshrc
RUN chsh -s /bin/zsh

# clean apt cache
RUN apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*