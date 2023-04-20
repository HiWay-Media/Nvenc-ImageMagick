FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone and install ffnvcodec
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make && \
    make install && \
    cd .. && \
    rm -rf nv-codec-headers

WORKDIR /tmp

# Clone FFmpeg repository
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg

# Configure and build FFmpeg with GPU acceleration
RUN cd ffmpeg && \
    ./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared && \
    make -j8 && \
    make install && \
    cd .. && \
    rm -rf ffmpeg

# Install ImageMagick and necessary libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        imagemagick libmagickwand-dev libfreetype6-dev gsfonts && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the container's default command to a shell prompt
CMD ["/bin/bash"]
