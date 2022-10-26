# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ARG CUE_VERSION="v0.4.3"
# install cue
RUN curl -L 'https://github.com/cue-lang/cue/releases/download/${CUE_VERSION}/cue_${CUE_VERSION}_linux_amd64.tar.gz' | tar zxf - -C /usr/local/bin \
    && cue version

# dagger
RUN cd /usr/local \
    && curl -L https://dl.dagger.io/dagger/install.sh | sh