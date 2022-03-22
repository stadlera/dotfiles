# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

## sway settings

# wayland/sway compability settings
export QT_QPA_PLATFORM="wayland-egl"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export MOZ_ENABLE_WAYLAND=1           # Firefox
export XDG_CURRENT_DESKTOP=sway

# jetbrains and other java apps
export _JAVA_AWT_WM_NONREPARENTING=1
export STUDIO_JDK=/usr/lib/jvm/java-17-openjdk/

# ssh agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# docker
export DOCKER_BUILDKIT=1

# go
export PATH=$PATH:$(go env GOPATH)/bin
export GO111MODULE=on

# editor
export EDITOR="nano"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

alias docker=podman
alias docker-compose=podman-compose

# start sway on login
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi

