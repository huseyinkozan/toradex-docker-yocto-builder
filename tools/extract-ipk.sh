#!/usr/bin/env bash

# set -x

OLD_PATH=$(pwd)
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function finish {
  cd $OLD_PATH
}
trap finish EXIT

err_exit() {
  echo "$@" 1>&2
  exit 1
}

PKG=
ALL=
HELP=


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP="true"
    shift # past argument
    ;;
    -a|--all)
    ALL="true"
    shift # past argument
    ;;
    # -s|--searchpath)
    # SEARCHPATH="$2"
    # shift # past argument
    # shift # past value
    # ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

PKG=$1

if [ ! -z "$HELP" ] || [ -z "$PKG" ] ;then
  echo "Usage : $0 [OPTIONS] <package>"
  echo ""
  echo "  OPTIONS:"
  echo "    -a, --all: extract all files at ipk, else only at usr/bin/*"
  echo ""
  exit
fi

cd $SCRIPT_PATH || err_exit "Failed to cd $SCRIPT_PATH"

if [ ! -f .env ]; then
  err_exit "Cannot find .env file"
fi

export $(cat .env | grep -v '#' | awk '/=/ {print $1$2$3}')

echo "Deploy path is: ${MY_YOCTO_DEPLOY}"

IPK_PATH=$(find "${MY_YOCTO_DEPLOY}/ipk" -iname "${PKG}_*.ipk" -print0)

if [ -z "$IPK_PATH" ]; then
  err_exit "ipk not found"
fi

echo "IPK_PATH = ${IPK_PATH}"

if [ -z "$ALL" ];then
  echo "  Extracting only at usr/bin/* files"
else
  echo "  Extracting all files"
fi




cd $SCRIPT_PATH || err_exit "Failed to cd $SCRIPT_PATH"

if [ -d extract-ipk-${PKG} ]; then
  rm -rf extract-ipk-${PKG} || err_exit "Cannot rm extract-ipk-${PKG}/ from $SCRIPT_PATH!"
  echo "Deleted old $SCRIPT_PATH/extract-ipk-${PKG}/"
fi
mkdir extract-ipk-${PKG} || err_exit "Cannot mkdir extract-ipk-${PKG} at $SCRIPT_PATH"
echo "Created $SCRIPT_PATH/extract-ipk-${PKG}/"




cd /tmp || err_exit "Cannot cd /tmp!"

if [ -d extract-ipk-${PKG} ];then
  rm -rf extract-ipk-${PKG} || err_exit "Cannot rm extract-ipk-${PKG}/ from /tmp !"
  echo "Deleted old /tmp/extract-ipk-${PKG}/"
fi
mkdir extract-ipk-${PKG} || err_exit "Cannot mkdir extract-ipk-${PKG}"
echo "Created /tmp/extract-ipk-${PKG}/"

cd extract-ipk-${PKG} || err_exit "Cannot cd extract-ipk-${PKG} !"

TMP_PATH=`pwd`
echo ""
echo "In " $(pwd)

cp $IPK_PATH . || err_exit "Cannop cp ${IPK_PATH} to ${TMP_PATH}"
ar -x -v ${PKG}_*.ipk || err_exit "Cannot extract ipk"
tar xf data.tar.xz || err_exit "Cannot extract from data.tar.xz"

tree .
echo ""

if [ ! -z "$ALL" ];then
  cp -R ./* ${SCRIPT_PATH}/extract-ipk-${PKG}/ || err_exit "Cannot copy extracted bins to called path ${SCRIPT_PATH}/extract-ipk-${PKG}/"
else
  cp usr/bin/* ${SCRIPT_PATH}/extract-ipk-${PKG}/ || err_exit "Cannot copy extracted bins to called path ${SCRIPT_PATH}/extract-ipk-${PKG}/"
fi

echo "Files copied from ${TMP_PATH}/usr/bin/* to ${SCRIPT_PATH}/extract-ipk-${PKG}/"

cd $SCRIPT_PATH || err_exit "Failed to cd $SCRIPT_PATH"

tree extract-ipk-${PKG}
echo ""


exit 0
