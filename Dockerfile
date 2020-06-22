ARG GO_VERSION="1.14.4"
ARG SINGULARITY_VERSION="3.5.3"
ARG LINUX_USER_NAME="neuro"

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
# FROM dorowu/ubuntu-desktop-lxde-vnc:bionic
FROM dorowu/ubuntu-desktop-lxde-vnc:focal
# docker pull dorowu/ubuntu-desktop-lxde-vnc:focal-lxqt

# Install singularity into the final image.
COPY --from=builder /usr/local/singularity /usr/local/singularity


# Install singularity's and lmod's runtime dependencies.
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
    && rm -rf /var/lib/apt/lists/*

# Needed to solve packaging issue inside LUA [see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891541]
RUN ln -s /usr/lib/x86_64-linux-gnu/lua/5.2/posix_c.so /usr/lib/x86_64-linux-gnu/lua/5.2/posix.so

# setup module system & singularity
ARG LINUX_USER_NAME
RUN mkdir -p /home/${LINUX_USER_NAME}/
RUN echo "if [ -f '/usr/share/module.sh' ]; then source /usr/share/module.sh; fi" >> /home/${LINUX_USER_NAME}/.bashrc
RUN echo "export MODULEPATH=/vnm/modules" >> /home/${LINUX_USER_NAME}/.bashrc
RUN echo "export SINGULARITY_BINDPATH=/vnm/" >> /home/${LINUX_USER_NAME}/.bashrc

# Necessary to pass the args from outside this build (it is defined before the FROM).
ARG GO_VERSION
ARG SINGULARITY_VERSION

ENV PATH="/usr/local/singularity/bin:${PATH}" \
    GO_VERSION=${GO_VERSION} \
    SINGULARITY_VERSION=${SINGULARITY_VERSION} \
    MODULEPATH=/opt/vnm


# add custom scripts
COPY ./scripts/* /usr/share/

# Use custom bottom panel configuration
COPY ./menus/panel /home/${LINUX_USER_NAME}/.config/lxpanel/LXDE/panels/panel

# Application and submenu icons
RUN mkdir -p /home/${LINUX_USER_NAME}/.config/lxpanel/LXDE/icons
COPY ./menus/icons/* /home/${LINUX_USER_NAME}/.config/lxpanel/LXDE/icons/
# Adding the vnm logo for a default icon
COPY virtualneuromachine_logo_small.png /home/${LINUX_USER_NAME}/.config/lxpanel/LXDE/icons/vnm.png
RUN chmod 644 /home/${LINUX_USER_NAME}/.config/lxpanel/LXDE/icons/*

# Main-menu config. Add Menu changes to vnm-applications.menu
COPY ./menus/lxde-applications.menu /etc/xdg/menus/
COPY ./menus/vnm-applications.menu /etc/xdg/menus/

RUN chmod 644 /etc/xdg/menus/lxde-applications.menu

# Sub-menu configs
COPY ./menus/submenus/*.directory /usr/share/desktop-directories/
RUN chmod 644 /usr/share/desktop-directories/*.directory

# Application configs
COPY ./menus/applications/*.desktop /usr/share/applications/
RUN chmod 644 /usr/share/applications/*

WORKDIR /vnm
