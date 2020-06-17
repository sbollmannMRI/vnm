FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
# based on this wonderful work https://github.com/fcwu/docker-ubuntu-vnc-desktop

RUN apt update \
    && apt install -y --no-install-recommends mesa-utils