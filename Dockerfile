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


# Install nvm and default node
ARG NODE_VERSION=18
ENV PNPM_HOME /root/.local/share/pnpm
ENV PATH $PNPM_HOME:$PATH
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && corepack enable \
    && pnpm setup

# Install Go
ENV GOPATH /root/go
ENV PATH $GOPATH/bin:$PATH
RUN yes | pacman -S go
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
ENV GOROOT /usr/lib/go
RUN go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct


# Finsih config
ADD .zshrc /root/.zshrc
RUN chsh -s /bin/zsh
RUN yes | pacman -Scc
WORKDIR /home