FROM archlinux:base-devel

WORKDIR /tmp
VOLUME [ "/root/.config", "/root/repos", "/root/.vscode-server/extensions", "/root/go/bin", "/var/lib/docker", "/root/.local/share/pnpm", "/root/.ssh" ]

ENV SHELL /bin/bash

#  basic tools
ADD mirrorlist /etc/pacman.d/mirrorlist
RUN yes | pacman -Syu
RUN yes | pacman -S curl tree net-tools wget git zsh fzf openssh exa fd && \
    ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -N '' -f /etc/ssh/ssh_host_dsa_key
# end

# z
RUN git clone https://gitee.com/xbmlz/rupa_z.git /root/.z_jump
# end

# zsh
RUN zsh -c 'git clone https://gitee.com/xbmlz/prezto.git "$HOME/.zprezto"' &&\
	  zsh -c 'setopt EXTENDED_GLOB' &&\
	  zsh -c 'for rcfile in "$HOME"/.zprezto/runcoms/z*; do ln -s "$rcfile" "$HOME/.${rcfile:t}"; done'
ENV SHELL /bin/zsh
# end zsh

# go
RUN yes | pacman -Syy; yes | pacman -S go

ENV GOPATH /root/go
ENV GOROOT /usr/lib/go
ENV PATH $GOPATH/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://goproxy.cn,direct && \
	go install github.com/silenceper/gowatch@latest
# end

# nvm
ENV NVM_DIR /root/.nvm
RUN git clone https://gitee.com/xbmlz/nvm.git $NVM_DIR
RUN sh ${NVM_DIR}/nvm.sh && \
    echo '' >> /root/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc && \
    echo '[ -s "${NVM_DIR}/nvm.sh" ] && { source "${NVM_DIR}/nvm.sh" }' >> /root/.zshrc && \
    echo '[ -s "${NVM_DIR}/bash_completion" ] && { source "${NVM_DIR}/bash_completion" } ' >> /root/.zshrc
# end

# pyenv
RUN git clone https://gitee.com/xbmlz/pyenv.git /root/.pyenv
RUN echo '' >> /root/.zshrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.zshrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.zshrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.zshrc
# end

# rust
ADD .cargo.cn.config /root/.cargo/config
ADD .cargo.cn.config /root/.cargo/config
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
ENV CARGO_HTTP_MULTIPLEXING=false
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# end

# java
RUN yes | pacman -S jre17-openjdk-headless jdk17-openjdk
ENV JAVA_HOME=/usr/lib/jvm/default/
ENV PATH=$JAVA_HOME/bin:$PATH
# end

# clash
RUN yes | pacman -S clash
# end

# dotfiles
ADD .bashrc /root/.bashrc
RUN echo '[ -f /root/.bashrc ] && source /root/.bashrc' >> /root/.zshrc; \
    echo '[ -f /root/.zshrc.local ] && source /root/.zshrc.local' >> /root/.zshrc
RUN mkdir -p /root/.config; \
    touch /root/.config/.profile; ln -s /root/.config/.profile /root/.profile; \
    touch /root/.config/.gitconfig; ln -s /root/.config/.gitconfig /root/.gitconfig; \
    touch /root/.config/.zsh_history; ln -s /root/.config/.zsh_history /root/.zsh_history; \
    touch /root/.config/.z; ln -s /root/.config/.z /root/.z; \
    touch /root/.config/.bashrc; ln -s /root/.config/.bashrc /root/.bashrc.local; \
    touch /root/.config/.zshrc; ln -s /root/.config/.zshrc /root/.zshrc.local;
# end