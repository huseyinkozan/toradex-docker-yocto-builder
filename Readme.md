# Toradex Docker Yocto Builder

To build Yocto images to Toradex, will need a supported OS. 

This repo is a proof of concept of using any GNU/Linux that supports Docker
can build Toradex images.


## Requirements

* GNU/Linux distro which have Docker support.
  * Tested with Ubuntu 20.04 and Manjaro.
* Install Docker and Docker Compose.
  * [Docker Install](https://docs.docker.com/engine/install/) 
  * [Docker Linux Post Install](https://docs.docker.com/engine/install/linux-postinstall/)
  * [Docker Compose Install](https://docs.docker.com/compose/install/)
* A disk path that have at least 60GB free space.
* Configure git. See [here](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) for more info.
  ```bash
  $ git config --global user.name "John Doe"
  $ git config --global user.email johndoe@example.com
  ```


## First Time Setup

Do below steps to setup;

* Create temporary dirs with helper tool;
  ```bash
  cd <where-this-project-located>
  
  ./tools/create-tmp-dirs.sh  /disk-path-that-have-lots-of-space  tmp-dir-name
  ```
  Path should have at least 60GB disk space. You may want to check `.env` file before use. ls

  If you are planning to use multiple builders, you should consider sharing downloads dir with `MY_YOCTO_DOWNLOADS` variable.
* Build container:
  ```bash
  cd <where-this-project-located>
  
  docker-compose up --build --no-start
  ```
  At any change to `.env` file, you may need to run above command.
* Take a look at `build/conf/local.conf` file and change for your needs. You may want to;
  * Set `MACHINE`,
  * Set `EXTRA_IMAGE_FEATURES`,
  * Uncomment license lines.

  Please do not change dirs that start with `/yocto-*`, unless know what you are doing.

* Start container;
  ```bash
  ./start.sh
  ```

* Fetch layers with repo tool.

  ```bash
  repo init -u https://git.toradex.com/toradex-manifest.git -m tdxref/default.xml -b refs/tags/6.4.0
  repo sync -j16  # -jXX: cpu core count
  ```

  Open a second console, and fix permissions before exit;
  ```bash
  docker-compose exec -u root builder bash

  chown yoctouser:yoctouser -R /yocto
  ```




## Additional Contents

Repo contains additionally;

* A  [rc.local](layers/meta-layer/recipes-fsl/fsl-rc-local/fsl-rc-local/rc.local.etc) file that setups for first launch.
* A message only [example](layers/meta-layer/recipes-example/example/example_0.1.bb).
* Some images located at [images](layers/meta-layer/recipes-images/images).
* An example [app](layers/meta-layer/recipes-software/app/app_git.bb).



## Usage

To start and enter the container;
```bash
cd <where-this-project-located>

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
cd <where-this-project-located>

./tools/extract-ipk.sh  app
```
Command will extract `/usr/bin/*` files into `tools/extract-ipk-app/` dir.


## root user

Default user is `yoctouser`. Probably, you will not need the root user while using the container. 

If you need, run below commands to use the `root` user.
```bash
cd <where-this-project-located>

docker-compose start
docker-compose exec -u root builder bash
```
