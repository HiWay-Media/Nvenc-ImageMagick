# syntax = docker/dockerfile:1.3-labs

ARG FFMPEG_VERSION="5.1.2"
FROM akashisn/ffmpeg:${FFMPEG_VERSION} AS ffmpeg-image
FROM akashisn/ffmpeg:${FFMPEG_VERSION}-qsv AS ffmpeg-image-qsv
FROM ghcr.io/akashisn/ffmpeg-windows:${FFMPEG_VERSION} AS ffmpeg-image-windows

#
# build env image
#
FROM ubuntu:22.04 AS ffmpeg-build-env

SHELL ["/bin/bash", "-e", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install build tools
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
    yasm
    imagemagick
EOT

# Environment
ARG FFMPEG_VERSION
ENV FFMPEG_VERSION="${FFMPEG_VERSION}" \
    PREFIX="/usr/local" \
    WORKDIR="/workdir"
WORKDIR ${WORKDIR}

# Copy build script
ADD ./scripts/*.sh ./


#
# ffmpeg library build image
#
FROM ffmpeg-build-env AS ffmpeg-library-build

# Environment
ARG TARGET_OS="Linux"
ENV TARGET_OS=${TARGET_OS}

# Run build
RUN bash ./build-library.sh

# Copy artifacts
RUN <<EOT
mkdir /build
cp --archive --parents --no-dereference ${PREFIX}/lib /build
cp --archive --parents --no-dereference ${PREFIX}/include /build
cp --archive --parents --no-dereference ${PREFIX}/ffmpeg_extra_libs /build
cp --archive --parents --no-dereference ${PREFIX}/ffmpeg_configure_options /build
EOT


#
# ffmpeg linux binary build base image
#
FROM ffmpeg-build-env AS ffmpeg-linux-build-base

# Environment
ENV TARGET_OS="Linux"

# Copy ffmpeg-library image
COPY --from=ghcr.io/akashisn/ffmpeg-library-build:linux / /


#
# ffmpeg linux binary build image
#
FROM ffmpeg-linux-build-base AS ffmpeg-linux-build

# Build ffmpeg
RUN bash ./build-ffmpeg.sh

# Copy run.sh
COPY <<'EOT' ${PREFIX}/run.sh
#!/bin/sh
export PATH=$(dirname $0)/bin:$PATH
exec $@
EOT

# Copy artifacts
RUN <<EOT
mkdir /build
chmod +x ${PREFIX}/run.sh
cp --archive --parents --no-dereference ${PREFIX}/run.sh /build
cp --archive --parents --no-dereference ${PREFIX}/bin/ff* /build
cp --archive --parents --no-dereference ${PREFIX}/configure_options /build
EOT


#
# ffmpeg linux binary build image
#
FROM ffmpeg-linux-build-base AS ffmpeg-linux-qsv-build


# Build ffmpeg
RUN bash ./build-ffmpeg.sh

# Copy run.sh
COPY <<'EOT' ${PREFIX}/run.sh
#!/bin/sh
export PATH=$(dirname $0)/bin:$PATH
export LD_LIBRARY_PATH=$(dirname $0)/lib:$LD_LIBRARY_PATH
exec $@
EOT

# Copy artifacts
RUN <<EOT
mkdir /build
chmod +x ${PREFIX}/run.sh
cp --archive --parents --no-dereference ${PREFIX}/run.sh /build
cp --archive --parents --no-dereference ${PREFIX}/bin/ff* /build
cp --archive --parents --no-dereference ${PREFIX}/configure_options /build
cp --archive --parents --no-dereference ${PREFIX}/lib/*.so* /build
EOT


# Build ffmpeg
RUN bash ./build-ffmpeg.sh

# Copy artifacts
RUN <<EOT
mkdir /build
cp ${PREFIX}/bin/ff* /build/
cp ${PREFIX}/configure_options /build/
EOT


#
# final ffmpeg-library image
#
FROM scratch AS ffmpeg-library

COPY --from=ffmpeg-library-build /build /


#
# final ffmpeg image
#
FROM ubuntu:22.04 AS ffmpeg

# Copy ffmpeg
COPY --from=ffmpeg-linux-build /build /

WORKDIR /workdir
ENTRYPOINT [ "ffmpeg" ]
CMD [ "--help" ]


