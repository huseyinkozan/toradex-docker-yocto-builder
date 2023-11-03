FILESEXTRAPATHS:prepend := "${THISDIR}/fsl-rc-local:"

SRC_URI += " \
    file://rc.local.etc \
"

do_install:append() {
    install -m 755 ${WORKDIR}/rc.local.etc ${D}/${sysconfdir}/rc.local
}
