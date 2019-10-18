FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY . /tmp

# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get install --no-install-recommends -yq curl gnupg2 git iproute2 language-pack-en lsb-release python3 \
        python-pip python-setuptools python-wheel \
    && pip install yamllint \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime \
    && mkdir -p /root/.config/puppet \
    && cp /tmp/analytics.yml /root/.config/puppet/analytics.yml \
    && cp /tmp/bash_aliases.sh /root/.bash_aliases \
    && gpg2 --list-keys || /bin/true \
    && cp /tmp/dirmngr.conf /root/.gnupg/dirmngr.conf \
    && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
    && curl -sSL -o /tmp/rvm-installer https://get.rvm.io \
    && bash /tmp/rvm-installer stable \
    && bash -lc "rvm requirements" \
    && bash -lc "rvm install 2.5.7" \
    && bash -lc "rvm use 2.5.7 --default" \
    && bash -lc "gem install bundle pdk puppet rake --no-doc" \
    && bash -lc "bundle config --global silence_root_warning 1" \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir -p /home/vscode/.config/puppet \
    && cp /tmp/analytics.yml /home/vscode/.config/puppet/analytics.yml \
    && cp /tmp/bash_aliases.sh /home/vscode/.bash_aliases \
    && chown "$USERNAME" /home/vscode/.config/puppet/analytics.yml /home/vscode/.bash_aliases \
    && apt-get -yq autoremove \
    && apt-get -yq clean \
    && rm -rf /usr/local/rvm/log/* \
    && rm -rf /usr/local/rvm/src/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    rm -rf /var/tmp/*
