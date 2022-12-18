FROM ubuntu:latest

# Change apt source
ADD sources.list /etc/apt/sources.list

# Update apt
RUN apt update && apt upgrade -y

# Install bascic tools
RUN apt install -y curl wget git vim zsh zip unzip sed

# Init config dir
RUN mkdir -p /root/.config
VOLUME [ "/root/.config", "/root/.local/share/pnpm", "/root/go/bin" ]

# Install oh-my-zsh
ARG ZSH_CUSTOM=/root/.oh-my-zsh/custom
RUN git clone https://gitee.com/mirrors/ohmyzsh.git ~/.oh-my-zsh
RUN git clone https://gitee.com/github-mirror-zsh/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
RUN ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
RUN git clone https://gitee.com/xbmlz/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://gitee.com/xbmlz/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://gitee.com/xbmlz/zsh-z.git $ZSH_CUSTOM/plugins/zsh-z

# Install nvm and default node
ARG NVM_DIR=/root/.nvm \
    && NODE_VERSION=v16
RUN curl -o- https://gitee.com/xbmlz/nvm/raw/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g pnpm \
    && pnpm config set store-dir /root/.local/share/pnpm

# Install Go
ARG GO_VERSION=1.18.9 
ENV GOPATH /root/go
ENV PATH $GOPATH/bin:$PATH
RUN wget https://golang.google.cn/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /root -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && mkdir -p $GOPATH/src $GOPATH/bin \
    && chmod -R 777 $GOPATH \
    && go env -w GOPROXY=https://goproxy.cn,direct


# Change default shell
ADD .zshrc /root/.zshrc
RUN chsh -s /bin/zsh

# clean apt cache
RUN apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*