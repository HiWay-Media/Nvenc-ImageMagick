FROM docker-registry.tngrm.io/cologno/tngrm-video-worker:5.1.2
LABEL org.opencontainers.image.authors="allan.nava@hiway.media"
#
RUN apt update
RUN apt-get install -y imagemagick
#
CMD ["/bin/bash"]
#
