# Toradex Docker Yocto Builder

To build Yocto images to Toradex, will need a supported OS. 

This repo is a proof of concept of using any GNU/Linux that supports Docker
can build Toradex images.


## Usage

First you need to enter container;
```bash
./start.sh
```

Then, you can use `bitbake`. For example;
* `bitbake example` : build `example` package.
* `bitbake minimal-image -k` : build minimal image.
* `bitbake minimal-image-sdk -c populate_sdk` : create minimal image SDK.
* `bitbake -c listtasks virtual/kernel` : list available tasks to give like `bitbake pacakge -c ...`.

Packages will be in `MY_YOCTO_DEPLOY/ipk/` dir, and images will be in `MY_YOCTO_DEPLOY/images/`.

For more information; [Toradex Wiki: openembedded-core](https://developer.toradex.com/knowledge-base/board-support-package/openembedded-core), [Yocto Manual](https://www.yoctoproject.org/docs/3.1.1/mega-manual/mega-manual.html).

## Tools

### First Time Setup

Do below steps to setup;
* Use a GNU/Linux distro which have Docker support.
* Install [docker](https://docs.docker.com/compose/install/) and [docker-compose](https://docs.docker.com/compose/install/).
* Create temporary dirs with helper tool;
  ```bash
  create-tmp-dirs.sh  /mnt/disk-that-have-lots-of-space  tmp-dir-name
  ```
  Path should have at least 60GB disk space.
* Build container:
  ```bash
  docker-compose up --build --no-start
  ```

### Extract IPK

You can extract ipk with `extract-ipk.sh`. For ex;
```bash
extract-ipk.sh  app
```
Command will extract `/usr/bin/*` files into `extract-ipk-app/` dir.


## root user

Default user is `yoctouser`. Probable you will not need the root user while using the container. 

If you need, to use the `root` user:
```bash
docker-compose exec -u root builder bash
```

## Notes

Docker image does not support mount loopback in container without privilaged.
Image writer script, `update.sh` does not work in container!
