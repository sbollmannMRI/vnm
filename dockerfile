FROM dorowu/ubuntu-desktop-lxde-vnc:bionic AS desktop
# based on this wonderful work https://github.com/fcwu/docker-ubuntu-vnc-desktop

# =====================================================================================
# INSTALL SINGULARITY
# =====================================================================================

# Install binary dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        libssl-dev \
        uuid-dev \
        libseccomp-dev \
        pkg-config \
        squashfs-tools \
        cryptsetup \
    && rm -rf /var/lib/apt/lists/*

# Build Go and Singularity
FROM desktop as install-singularity

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

# Install Singularity
FROM desktop as runner

COPY --from=install-singularity /usr/local /usr/local

WORKDIR /vnm
