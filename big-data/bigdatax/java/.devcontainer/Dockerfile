# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.187.0/containers/java/.devcontainer/base.Dockerfile

# [Choice] Java version: 11, 16
ARG VARIANT="16"
FROM mcr.microsoft.com/vscode/devcontainers/java:0-${VARIANT}

# [Option] Install Maven
ARG INSTALL_MAVEN="false"
ARG MAVEN_VERSION=""
# [Option] Install Gradle
ARG INSTALL_GRADLE="false"
ARG GRADLE_VERSION=""
RUN if [ "${INSTALL_MAVEN}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install maven \"${MAVEN_VERSION}\""; fi \
    && if [ "${INSTALL_GRADLE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install gradle \"${GRADLE_VERSION}\""; fi

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install the Fish Shell
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install --no-install-recommends fish fzf
    
SHELL ["/usr/bin/fish", "-c"]
USER vscode
RUN curl -sL https://git.io/fisher | source && \
    fisher install jorgebucaran/fisher && \
    fisher install oh-my-fish/theme-bobthefish && \
    echo "set -g theme_nerd_fonts yes" > ~/.config/fish/config.fish && \
    fisher install jethrokuan/z && \
    fisher install jethrokuan/fzf  && \
    chsh -s $(which fish) $(whoami)
SHELL ["/bin/sh", "-c"]
USER root

# [Optional] Uncomment this section to install additional OS packages.
 RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends python3-pip python3-setuptools

# install java kernel
USER vscode
RUN pip3 install jupyter pandas apyori
RUN cd ~ && \
    wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.py --user
USER root

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1