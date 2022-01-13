# Toradex Docker Yocto Builder

To build Yocto images to Toradex, will need a supported OS. 

This repo is a proof of concept of using any GNU/Linux that supports Docker
can build Toradex images.


## Requirements

* GNU/Linux distro which have Docker support.
  * Tested with Ubuntu 20.04 and Manjaro.
* [Docker](https://docs.docker.com/compose/install/) and [Docker  Compose](https://docs.docker.com/compose/install/).
* A disk path that have at least 60GB free space.


## First Time Setup

Do below steps to setup;

* Create temporary dirs with helper tool;
  ```bash
  ./tools/create-tmp-dirs.sh  /disk-path-that-have-lots-of-space  tmp-dir-name
  ```
  Path should have at least 60GB disk space. You may want to check `.env` file before use. 

  If you are planning to use multiple builders, you should consider sharing downloads dir with `MY_YOCTO_DOWNLOADS` variable.
* Build container:
  ```bash
  docker-compose up --build --no-start
  ```
  At any change to `.env` file, you may need to run above command.

## Usage

To start and enter the container;
```bash
./start.sh
```

Then, you can use `bitbake`. For example;
* `bitbake example` : build `example` package.
* `bitbake minimal-image -k` : build minimal image.
* `bitbake minimal-image-sdk -c populate_sdk` : create minimal image SDK.
* `bitbake -c listtasks virtual/kernel` : list available tasks to give like `bitbake pacakge -c ...`.

Packages will be in `$MY_YOCTO_DEPLOY/ipk/` dir, and images will be in `$MY_YOCTO_DEPLOY/images/`.

For more information; [Toradex Wiki: openembedded-core](https://developer.toradex.com/knowledge-base/board-support-package/openembedded-core), [Yocto Manual](https://www.yoctoproject.org/docs/3.1.1/mega-manual/mega-manual.html).


## Extract IPK

You can extract ipk with `extract-ipk.sh`. For ex;
```bash
./tools/extract-ipk.sh  app
```
Command will extract `/usr/bin/*` files into `tools/extract-ipk-app/` dir.


## root user

Default user is `yoctouser`. Probably, you will not need the root user while using the container. 

If you need, run below commands to use the `root` user.
```bash
docker-compose start
docker-compose exec -u root builder bash
```
