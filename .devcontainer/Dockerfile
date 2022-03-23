# [Choice] Ruby version: 2, 2.7, 2.6, 2.5
ARG VARIANT=2
FROM mcr.microsoft.com/vscode/devcontainers/ruby:${VARIANT}

# Install Rails
RUN gem install rails webdrivers

ARG NODE_VERSION="lts/*"
RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends liblua5.1-0 mariadb-client p7zip-full cron

# [Optional] Uncomment this line to install additional gems.
# RUN gem install <your-gem-names-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

COPY --from=docker:latest /usr/local/bin/dockerd /usr/local/bin/dockerd
COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:latest /usr/local/bin/runc /usr/local/bin/runc
COPY --from=docker:latest /usr/local/bin/containerd /usr/local/bin/containerd
COPY --from=docker:latest /usr/local/bin/containerd-shim /usr/local/bin/containerd-shim
COPY --from=docker:latest /usr/local/bin/containerd-shim-runc-v2 /usr/local/bin/containerd-shim-runc-v2

COPY --from=amazon/aws-cli /usr/local/aws-cli/v2/current /usr/local
