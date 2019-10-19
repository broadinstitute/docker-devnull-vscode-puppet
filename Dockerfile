FROM ruby:2.5.7-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

COPY . /tmp

# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get install --no-install-recommends -yq curl gcc git iproute2 lsb-release make python3 \
        python-pip python-setuptools python-wheel \
    && gem install bundle pdk puppet rake --no-doc \
    && bundle config --global silence_root_warning 1 \
    && pip install yamllint \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime \
    && mkdir -p /root/.config/puppet \
    && cp /tmp/analytics.yml /root/.config/puppet/analytics.yml \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir -p /home/vscode/.config/puppet \
    && cp /tmp/analytics.yml /home/vscode/.config/puppet/analytics.yml \
    && cp /tmp/bash_aliases.sh /home/vscode/.bash_aliases \
    && chown -R ${USERNAME}:${USERNAME} /home/vscode/.[a-z]* \
    && apt-get -yq autoremove \
    && apt-get -yq clean \
    && rm -rf /usr/local/rvm/log/* \
    && rm -rf /usr/local/rvm/src/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    rm -rf /var/tmp/*
