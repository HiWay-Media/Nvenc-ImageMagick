FROM ghcr.io/hiway-media/nvenc-docker:latest
LABEL org.opencontainers.image.authors="allan.nava@hiway.media"
#
RUN apk add --no-cache imagemagick
#
CMD ["/bin/bash"]
#
