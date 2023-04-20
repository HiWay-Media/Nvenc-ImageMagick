FROM docker-registry.tngrm.io/cologno/tngrm-video-worker:5.1.2
FROM ghcr.io/hiway-media/nvenc-docker:latest
LABEL org.opencontainers.image.authors="allan.nava@hiway.media"
#
RUN apt-get update
RUN apt-get install -y imagemagick
