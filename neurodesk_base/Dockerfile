ARG GO_VERSION="1.14.4"
ARG SINGULARITY_VERSION="3.5.3"

# Build Singularity.
FROM golang:${GO_VERSION}-buster as builder

# Necessary to pass the arg from outside this build (it is defined before the FROM).
ARG SINGULARITY_VERSION

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        cryptsetup \
        libssl-dev \
        uuid-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/hpcng/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz" \
    | tar -xz \
    && cd singularity \
    && ./mconfig -p /usr/local/singularity \
    && cd builddir \
    && make \
    && make install


# Create final image.
# Same ubuntu version as desktop container: https://github.com/fcwu/docker-ubuntu-vnc-desktop
FROM ubuntu:20.04

# Install singularity into the final image.
COPY --from=builder /usr/local/singularity /usr/local/singularity

ENV DEBIAN_FRONTEND=noninteractive

# Install packages with --no-install-recommends to keep things slim
# 1) singularity's and lmod's runtime dependencies.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        squashfs-tools \
        lua-bit32 \
        lua-filesystem \
        lua-json \
        lua-lpeg \
        lua-posix \
        lua-term \
        lua5.2 \
        lmod \
        git \
        aria2 \
        less \
        nano \
        openssh-client \
        vim \
    && rm -rf /var/lib/apt/lists/*

# add module script
COPY ./config/module.sh /usr/share/

# setup module system & singularity
COPY ./config/.bashrc /etc/skel/.bashrc

# Necessary to pass the args from outside this build (it is defined before the FROM).
ARG GO_VERSION
ARG SINGULARITY_VERSION

ENV PATH="/usr/local/singularity/bin:${PATH}" \
    GO_VERSION=${GO_VERSION} \
    SINGULARITY_VERSION=${SINGULARITY_VERSION} \
    MODULEPATH=/opt/vnm