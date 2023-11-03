SUMMARY = "An example app"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# DEPENDS = ""

RDEPENDS:${PN} = " \
  bash \
  cpufrequtils \
"

FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI += " \
  file://_files \
"

do_install:append() {

  # etc
  install -d ${D}${sysconfdir}/app/
  # lib
  install -d ${D}${systemd_system_unitdir}/
  # usr
  install -d ${D}${bindir}/
  install -d ${D}${datadir}/app/

  # etc
  install -m 0644 ${WORKDIR}/_files/etc/app/cpu-governor          ${D}${sysconfdir}/app/
  # lib
  install -m 0644 ${WORKDIR}/_files/lib/systemd/system/*.service  ${D}${systemd_system_unitdir}/
  # usr
  install -m 0755 ${WORKDIR}/_files/usr/bin/*.sh                  ${D}${bindir}/
  install -m 0644 ${WORKDIR}/_files/usr/share/app/*.txt           ${D}${datadir}/app/
}

FILES:${PN} += " \
  \
  ${sysconfdir}/app/ \
  \
  ${systemd_system_unitdir}/ \
  \
  ${bindir}/ \
  ${datadir}/app/ \
"

SYSTEMD_SERVICE:${PN} = "app.service"
SYSTEMD_SERVICE:${PN} += " app-cpu-governor.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
