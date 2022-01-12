require minimal-image.bb

SUMMARY = "Embedded Linux Multimedia Image"
DESCRIPTION = "Image with Qt and multimedia features"

#Prefix to the resulting deployable tarball name
export IMAGE_BASENAME = "Multimedia-Image"

# Show Tezi EULA license
TEZI_SHOW_EULA_LICENSE ?= "1"
TEZI_SHOW_EULA_LICENSE_apalis-tk1 ?= "0"

TEZI_SHOW_EULA_LICENSE_use-mainline-bsp ?= "0"
TEZI_SHOW_EULA_LICENSE_colibri-imx6_use-mainline-bsp ?= "1"
TEZI_SHOW_EULA_LICENSE_apalis-imx6_use-mainline-bsp ?= "1"

IMAGE_INSTALL += " \
    packagegroup-tdx-cli \
    packagegroup-tdx-graphical \
    packagegroup-tdx-qt5 \
    packagegroup-fsl-isp \
    \
    bash \
    coreutils \
    less \
    makedevs \
    mime-support \
    util-linux \
    v4l-utils \
    \
    gpicview \
    media-files \
"
