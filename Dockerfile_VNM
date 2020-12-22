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
# Based on this wonderful work https://github.com/fcwu/docker-ubuntu-vnc-desktop
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# Install singularity into the final image.
COPY --from=builder /usr/local/singularity /usr/local/singularity



# This bundles all installs to get a faster container build:
# Add Visual Studio code and nextcloud client
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vs-code.list \
    && add-apt-repository ppa:nextcloud-devs/client

# Install packages with --no-install-recommends to keep things slim
# 1) singularity's and lmod's runtime dependencies.
# 2) various tools
# 3) julia
# 4) nextcloud-client
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        cryptsetup \
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
        code \
        emacs \
        htop \
        imagemagick \
        less \
        nano \
        openssh-client \
        python3-pip \
        rsync \
        tree \
        vim \
        gcc \
        python3-dev \
        graphviz \
        libzstd1 \
        libgfortran5 \
        zlib1g-dev \
        zip \
        nextcloud-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list.d/vs-code.list

# add module script
COPY ./config/module.sh /usr/share/

# install nipype
RUN pip3 install nipype \
    && rm -rf /root/.cache/pip \
    && rm -rf /home/ubuntu/.cache/

# setup module system & singularity
COPY ./config/.bashrc /etc/skel/.bashrc

# Necessary to pass the args from outside this build (it is defined before the FROM).
ARG GO_VERSION
ARG SINGULARITY_VERSION

ENV PATH="/usr/local/singularity/bin:${PATH}" \
    GO_VERSION=${GO_VERSION} \
    SINGULARITY_VERSION=${SINGULARITY_VERSION} \
    MODULEPATH=/opt/vnm

# configure tiling of windows SHIFT-ALT-CTR-{Left,right,top,Bottom} and other openbox desktop mods
COPY ./config/rc.xml /etc/xdg/openbox

# configure ITKsnap
COPY ./config/.itksnap.org /etc/skel/.itksnap.org
COPY ./config/mimeapps.list /etc/skel/.config/mimeapps.list

# Use custom bottom panel configuration
COPY ./config/panel /etc/skel/.config/lxpanel/LXDE/panels/panel

# Application and submenu icons
WORKDIR /

RUN git clone https://github.com/NeuroDesk/neurodesk.git /neurodesk

WORKDIR /neurodesk
RUN bash build.sh --lxde --edit \
    && bash install.sh \
    && ln -s /vnm/containers /neurodesk/local/containers \
    && mkdir -p /etc/skel/Desktop/ \
    && ln -s /vnm /etc/skel/Desktop/


# configure where new home-directories are created
# The homedirectory is configured on startup: https://github.com/fcwu/docker-ubuntu-vnc-desktop/blob/develop/rootfs/startup.sh
# COPY ./config/startup.sh /startup.sh

# rebuild