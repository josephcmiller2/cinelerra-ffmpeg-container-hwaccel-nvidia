#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:22.04
#FROM 8.0-ffmpeg3.4-ubuntu18.04
#FROM 8.2-ffmpeg4.1-ubuntu18.04

ENV TZ=America/Denver
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  mkdir /shared && \
  apt-get update && \
  apt-get install -y gnupg wget software-properties-common snapd pulseaudio

RUN \
  add-apt-repository -y ppa:linuxuprising/libpng12 && \
  apt-get update && \
  apt-get install -y libpng12-0 libxv1 libxft2 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 vim uidmap rsyslog screen

COPY cinelerra-8-x86_64.tar.xz /root/cinelerra-8-x86_64.tar.xz

RUN \
  cd /root && tar -xvf cinelerra-8-x86_64.tar.xz && \
  rm -f /root/cinelerra-8-x86_64.tar.xz

RUN \
  apt-get install -y aptitude

RUN \
  sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get build-dep -y ffmpeg && \
  mkdir /root/ffmpeg && cd /root/ffmpeg && \
  apt-get source ffmpeg

RUN \
  wget -q -O - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub | apt-key add - && \
  wget -q -O - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add -


RUN \
  apt-get install -y nasm build-essential libffmpeg-nvenc-dev

RUN \
  cd /root/ffmpeg && \
  sed -i 's/dh_shlibdeps /dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info /g' $(find . -maxdepth 1 -type d -name 'ffmpeg-*')/debian/rules && \
  sed -i 's/CONFIG :=/CONFIG := --enable-nonfree/' $(find . -maxdepth 1 -type d -name 'ffmpeg-*')/debian/rules && \
  apt-get -y --build source ffmpeg

RUN \
  cd /root/ffmpeg && \
  dpkg -i $(ls *.deb | grep -E -v 'libavcodec-extra58|libavfilter7|libavformat58|ffmpeg-doc|libavcodec-extra')

ENV NVIDIA_DRIVER_VERSION 525_525.85.12
ENV NVIDIA_DRIVER_RELEASE 0ubuntu1
ENV ARCH amd64
ENV NVIDIA_DOWNLOAD_PREFIX https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/

RUN \
  mkdir /root/nvidia && cd /root/nvidia && \
  wget ${NVIDIA_DOWNLOAD_PREFIX}/libnvidia-encode-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb && \
  wget ${NVIDIA_DOWNLOAD_PREFIX}/libnvidia-decode-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb && \
  wget ${NVIDIA_DOWNLOAD_PREFIX}/libnvidia-compute-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb && \
  dpkg --force-all -i \
    libnvidia-encode-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb \
    libnvidia-decode-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb \
    libnvidia-compute-${NVIDIA_DRIVER_VERSION}-${NVIDIA_DRIVER_RELEASE}_${ARCH}.deb

RUN \
  apt-get update && \
  apt-get install -y git && \
  cd /root && git clone https://github.com/anthwlock/untrunc.git && \
  cd /root/untrunc && \
  make && \
  cp untrunc /usr/local/bin

COPY files/startcontainer.sh /usr/bin/startcontainer.sh
COPY files/subuid /etc/subuid
COPY files/subgid /etc/subgid

# Set environment variables
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
