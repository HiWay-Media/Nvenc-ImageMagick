FROM alpine:latest

RUN apk add --no-cache build-base git yasm nasm tar xz \
 && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main imagemagick-dev

WORKDIR /tmp

# Download and extract ffmpeg
RUN wget https://ffmpeg.org/releases/ffmpeg-6.0.tar.xz \
 && tar -xf ffmpeg-6.0.tar.xz \
 && rm ffmpeg-6.0.tar.xz

# Download and build nv-codec-headers
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
 && cd nv-codec-headers \
 && make \
 && make install \
 && cd .. \
 && rm -rf nv-codec-headers

# Configure and build ffmpeg with nvenc support
RUN cd ffmpeg-6.0 \
 && ./configure --enable-nvenc \
 && make \
 && make install \
 && cd .. \
 && rm -rf ffmpeg-6.0

CMD ["/bin/bash"]
