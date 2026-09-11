FROM mcr.microsoft.com/devcontainers/java:1-11-bookworm

ARG ARTEMIS_VERSION=18.2.0
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        fontconfig \
        fonts-dejavu \
        fonts-dejavu-core \
        libexpat1 \
        libfreetype6 \
        libfontconfig1 \
        libxext6 \
        libxi6 \
        libxrender1 \
        libxrandr2 \
        libxtst6 \
        tar \
        x11-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN curl -fsSL "https://github.com/sanger-pathogens/Artemis/releases/download/v${ARTEMIS_VERSION}/artemis-unix-release-${ARTEMIS_VERSION}.tar.gz" -o /tmp/artemis.tar.gz \
    && tar -xzf /tmp/artemis.tar.gz -C /opt \
    && rm /tmp/artemis.tar.gz \
    && chmod +x /opt/artemis/art \
    && ln -s /opt/artemis/art /usr/local/bin/artemis

ENV ARTEMIS_HOME=/opt/artemis
ENV ARTEMIS_JVM_FLAGS="-mx2g -ms100m -Duser.home=/home/vscode -Djava.io.tmpdir=/tmp"
ENV PATH="/opt/artemis:/opt/artemis/dist:/opt/artemis/etc:${PATH}"
