FROM debian:11 AS builder

RUN dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y build-essential git yasm unzip wget sysstat nasm libc6:i386 \
		libavcodec-dev libavformat-dev libavutil-dev pkgconf g++ freeglut3-dev \
		libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

WORKDIR /tmp
COPY . .


## Prepare
RUN apt-get update
RUN apt-get install -y \
    curl diffutils file coreutils m4 xz-utils nasm python3 python3-pip appstream

## Install dependencies
RUN apt-get install -y \
    autoconf automake build-essential cmake git libass-dev libbz2-dev libfontconfig1-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev libjansson-dev liblzma-dev libmp3lame-dev libnuma1 libnuma-dev libogg-dev libopus-dev libsamplerate-dev libspeex-dev libtheora-dev libtool libtool-bin libturbojpeg0-dev libvorbis-dev libx264-dev libxml2-dev libvpx-dev m4 make nasm ninja-build patch pkg-config python tar zlib1g-dev autopoint imagemagick gsfonts wget libc6 libc6-dev

## Intel CSV dependencies
RUN apt-get install -y libva-dev libdrm-dev
    
## GTK GUI dependencies
RUN apt-get install -y \ 
    intltool libayatana-appindicator-dev libdbus-glib-1-dev libglib2.0-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev libgudev-1.0-dev libnotify-dev libwebkit2gtk-4.0-dev

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
	&& cd nv-codec-headers \
	&& make \
	&& make install

#Install x264
 RUN git clone https://code.videolan.org/videolan/x264.git \
 && cd x264 \
 && ./configure --disable-cli --enable-static --enable-shared --enable-strip \
 && make \
 &&  make install \
 && ldconfig

RUN wget https://ffmpeg.org/releases/ffmpeg-5.1.2.tar.xz \
 && tar -xf ffmpeg-5.1.2.tar.xz \
 && rm ffmpeg-5.1.2.tar.xz

# Configure and build ffmpeg with nvenc support
RUN cd ffmpeg-5.1.2 
RUN ./configure \
    --enable-nonfree \
    --enable-nvenc \
    --enable-cuda \
    --enable-cuvid \
    --enable-cuda-nvcc \
    --enable-gpl \
    --enable-version3 \
    --enable-static \
    --disable-debug \
    --disable-ffplay \
    --disable-indev=sndio \
    --disable-outdev=sndio \
    --cc=gcc \
    --enable-fontconfig \
    --enable-gray \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvpx \
    --enable-libx264  \
 && make install \
 && cd ..


## Runtime dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    # For optical drive listing:
    lsscsi \
    # For watchfolder
    bash \
    coreutils \
    yad \
    findutils \
    expect \
    tcl8.6 \
    wget \
    git
    
## Handbrake dependencies
RUN apt-get install -y \
    libass9 \
    libavformat58 \
    libavutil56 \
    libbluray2 \
    libc6 \
    libcairo2 \
    libdvdnav4 \
    libdvdread8 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer1.0-0 \
    libgtk-3-0 \
    libgudev-1.0-0 \
    libjansson4 \
    libpango-1.0-0 \
    libsamplerate0 \
    libswresample3 \
    libswscale5 \
    libtheora0 \
    libvorbis0a \
    libvorbisenc2 \
    libx264-160 \
    libx265-192 \
    libxml2 \
    libturbojpeg0


## Cleanup
RUN rm -rf docker-handbrake
RUN apt-get remove wget git -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    apt-get purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]


