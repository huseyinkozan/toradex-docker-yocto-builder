#!/usr/bin/env bash

# set -x

OLD_PATH=$(pwd)
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_PATH=`cd $SCRIPT_PATH/..; pwd`

function finish {
  cd $OLD_PATH
}
trap finish EXIT

err_exit() {
  echo "$@" 1>&2
  exit 1
}

if [ -z "$1" ] || [ -z "$2" ] ;then
  echo "Usage : $0 </path/to/create> <dir-name>"
  echo ""
  exit
fi

if [ ! -d "$1" ]; then
    err_exit "Path does not exist: $1"
fi

cd $ROOT_PATH || err_exit "Failed to cd $ROOT_PATH"

if [ -f ".env" ]; then
    err_exit ".env file exist, delete it before run this script"
fi

cd $1 || err_exit "Failed to cd $1"

if [ -d "$2" ]; then
    err_exit "Dir exist: $2"
fi

mkdir $2 || err_exit "Failed to mkdir $2"

cd $2 || err_exit "Failed to cd $1/$2"

mkdir deploy    || err_exit "Failed to mkdir $1/$2/deploy"
mkdir downloads || err_exit "Failed to mkdir $1/$2/downloads"
mkdir sstate    || err_exit "Failed to mkdir $1/$2/sstate"
mkdir tmp       || err_exit "Failed to mkdir $1/$2/tmp"
mkdir layers    || err_exit "Failed to mkdir $1/$2/layers"

cd $ROOT_PATH || err_exit "Failed to cd $ROOT_PATH"

echo "# created by first-time-setup.sh"     >  .env
echo "MY_YOCTO_DEPLOY    = $1/$2/deploy"    >> .env
echo "MY_YOCTO_DOWNLOADS = $1/$2/downloads" >> .env
echo "MY_YOCTO_SSTATE    = $1/$2/sstate"    >> .env
echo "MY_YOCTO_TMP       = $1/$2/tmp"       >> .env
echo "MY_YOCTO_LAYERS    = $1/$2/layers"    >> .env

echo "Created $1/$2 and .env file"
