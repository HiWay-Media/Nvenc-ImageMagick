# Docker FFmpeg Nvenc with ImageMagick

[![Docker FFmpeg6.0](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish-ffmpeg6.yml/badge.svg)](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish-ffmpeg6.yml)
[![Dockerimage with Dockerfile](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish.yml)
[![Docker FFmpeg6.0 Nvenc 11 ImageMagick](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish-ffmpeg6-nvenc11.yml/badge.svg)](https://github.com/HiWay-Media/Nvenc-ImageMagick/actions/workflows/docker-publish-ffmpeg6-nvenc11.yml)

Nvenc-ImageMagick is a repository that combines the power of NVIDIA's NVENC (NVIDIA Video Encoder) with ImageMagick, a versatile image manipulation tool. It provides a Docker image that allows you to perform accelerated image encoding and processing using NVIDIA GPUs.

### Prerequisites

To use Nvenc-ImageMagick, ensure that you have the following:

- A machine with an NVIDIA GPU that supports NVENC.
- Docker installed on the machine.
- NVIDIA Docker runtime installed (for GPU support).

### Usage

To utilize Nvenc-ImageMagick, follow these steps:

1. Pull the Nvenc-ImageMagick image from Docker Hub:
```shell
docker pull hiwaymedia/nvenc-imagemagick:latest
```

2.Run the Docker container with your desired ImageMagick commands. For example:

```shell

docker run --gpus all \
  --volume /path/to/input:/data/input \
  --volume /path/to/output:/data/output \
  hiwaymedia/nvenc-imagemagick:latest \
  convert /data/input/input.jpg -resize 800x600 /data/output/output.jpg
 ```
Customize the input and output paths and the ImageMagick command as per your requirements. This example resizes an input image (input.jpg) to a width of 800 pixels and a height of 600 pixels.

3. Monitor the image processing and retrieve the processed image from the output directory.

For more detailed usage examples and additional information, please refer to the documentation.

### Contributing
Contributions to Nvenc-ImageMagick are welcome! If you have any suggestions, improvements, or bug fixes, feel free to open an issue or submit a pull request.

### License
This project is licensed under the MIT License.
