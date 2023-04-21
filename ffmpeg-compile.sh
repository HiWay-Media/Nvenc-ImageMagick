#!/bin/bash
# Automatically compile and install FFMPEG with NVIDIA hardware acceleration on Debian 11
# Includes cuvid, cuda, nvenc, nvdec, and non-free libnpp
# Based on:
#  https://www.tal.org/tutorials/ffmpeg_nvidia_encode
#  https://developer.nvidia.com/blog/nvidia-ffmpeg-transcoding-guide/
#
# Abort on error
set -e
#
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd nv-codec-headers && sudo make install && cd �~@~S

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

sudo apt-get install build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev imagemagick

./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared

make -j 8

sudo make install