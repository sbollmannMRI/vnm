FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
# based on this wonderful work https://github.com/fcwu/docker-ubuntu-vnc-desktop

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        libssl-dev \
        uuid-dev \
        libseccomp-dev \
        pkg-config \
        squashfs-tools \
        cryptsetup \
    && apt-get -y clean

WORKDIR /tmp

ENV GO_VERS=1.14.4 \
    SINGULARITY_VERS=3.5.3

RUN curl -SLO "https://dl.google.com/go/go${GO_VERS}.linux-amd64.tar.gz" \
    && tar --strip 1 -C /usr/local -xzf "go${GO_VERS}.linux-amd64.tar.gz" \
    && rm -rf go*

RUN curl -SLO "https://github.com/hpcng/singularity/releases/download/v${SINGULARITY_VERS}/singularity-${SINGULARITY_VERS}.tar.gz" \
    && tar -xzf "singularity-${SINGULARITY_VERS}.tar.gz" \
    && cd singularity \
    && ./mconfig -p /usr/local \
    && cd builddir \
    && make \
    && make install \
    && rm -rf singularity*

WORKDIR /vnm
