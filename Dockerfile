FROM docker-registry.tngrm.io/cologno/tngrm-video-worker:5.1.2
FROM ghcr.io/hiway-media/nvenc-docker:latest
LABEL org.opencontainers.image.authors="allan.nava@hiway.media"
#
RUN <<EOT
rm -rf /var/lib/apt/lists/*
sed -i -r 's!(deb|deb-src) \S+!\1 http://jp.archive.ubuntu.com/ubuntu/!' /etc/apt/sources.list
apt-get update
apt-get install -y \
    autopoint \
    build-essential \
    clang \
    curl \
    gettext \
    git \
    gperf \
    libtool \
    lzip \
    make \
    mingw-w64 \
    mingw-w64-tools \
    nasm \
    p7zip \
    pkg-config \
    subversion \
    yasm \
    imagemagick
EOT
