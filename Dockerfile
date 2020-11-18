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
# Add Visual Studio code
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vs-code.list

# install nextcloud client
RUN add-apt-repository ppa:nextcloud-devs/client

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
        code \
        emacs \
        fish \
        git-annex \
        gimp \
        htop \
        imagemagick \
        less \
        nano \
        openssh-client \
        python3-pip \
        rclone \
        rsync \
        tree \
        vim \
        gcc \
        python3-dev \
        graphviz \
        libzstd1 \
        julia \
        libjulia1 \
        libgfortran5 \
        zlib1g-dev \
        zip \
        nextcloud-client \
    && rm -rf /var/lib/apt/lists/*


# # Install packages without --no-install-recomends where needed:
# RUN apt-get update \
#     && apt-get install -y \
#     && rm -rf /var/lib/apt/lists/*

# add module script
COPY ./config/module.sh /usr/share/

# cleanup vs-code.list file to avoid apt error:
RUN rm /etc/apt/sources.list.d/vs-code.list

# install datalad & niype
RUN pip3 install datalad datalad_container nipype \
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
# The subtree of neurodesk does not work and breaks most of the icons? 
# Need to check if this happens again 
# Also, it breaks the git association and an update of the neurodesk is not possible within VNM 
# -> solution for now: fixed icons manually and clone git first, then replace with subtree files
COPY neurodesk /neurodesk

WORKDIR /neurodesk
# RUN git fetch --all --tags
# RUN git checkout tags/20201104 -b latest
RUN bash build.sh --lxde --edit
RUN bash install.sh

RUN ln -s /vnm/containers /neurodesk/local/containers

RUN mkdir -p /etc/skel/Desktop/
RUN ln -s /vnm /etc/skel/Desktop/


# configure where new home-directories are created
# The homedirectory is configured on startup: https://github.com/fcwu/docker-ubuntu-vnc-desktop/blob/develop/rootfs/startup.sh
# COPY ./config/startup.sh /startup.sh

# rebuild