SUMMARY = "An example app"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# DEPENDS = ""

RDEPENDS_${PN} = " \
  bash \
  cpufrequtils \
"

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " \
  file://_files \
"

do_install_append() {

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

FILES_${PN} += " \
  \
  ${sysconfdir}/app/ \
  \
  ${systemd_system_unitdir}/ \
  \
  ${bindir}/ \
  ${datadir}/app/ \
"

SYSTEMD_SERVICE_${PN} = "app.service"
SYSTEMD_SERVICE_${PN} += " app-cpu-governor.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"
