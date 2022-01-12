FROM ubuntu:18.04

# enable apt features and update
RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository universe
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Copied required packages from;
#  https://www.yoctoproject.org/docs/3.1.1/mega-manual/mega-manual.html#required-packages-for-the-build-host
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
        pylint3 xterm
#  https://www.yoctoproject.org/docs/3.1.1/mega-manual/mega-manual.html#migration-3.1-minimum-system-requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libc-dev-bin
# Other useful packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        screen \
        tmux \
        sudo \
        iputils-ping \
        fluxbox \
        tightvncserver \
        nano \
        vim \
        bash-completion \
        libncurses5 \
        libncurses5-dev \
        tree

# setup locale, taken from https://hub.docker.com/_/ubuntu
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8


# repo tool

# repo needs git, python, wget to download repo
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget git-core python3 python3-pip python3-pexpect python3-git python3-jinja2
# fix for the shebang
RUN ln -s /usr/bin/pip3 /usr/bin/pip && \
    ln -s /usr/bin/python3 /usr/bin/python
# download repo tool from google
RUN wget https://storage.googleapis.com/git-repo-downloads/repo -O /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo


# cleanup apt caches
RUN apt-get clean && rm -rf /var/lib/apt/lists/*



# user and permissions

# create yoctouser
RUN useradd -ms /bin/bash yoctouser
# bashrc
RUN touch /home/yoctouser/.bashrc
RUN echo "source /"

RUN echo '\n\
if [ -d /yocto ];then \n\
\n\
  echo "cd /yocto ..."\n\
  cd /yocto\n\
\n\
  if [ -z "$(ls -A /yocto/layers)" ]; then\n\
    echo "/yocto/layers is empty. Dowloading with repo tool."\n\
    echo "repo init ..."\n\
    repo init -u https://git.toradex.com/toradex-manifest.git   -b refs/tags/5.4.0   -m tdxref/default.xml\n\
    if [ $? -eq 0 ]; then\n\
      echo "repo sync .."\n\
      repo sync\n\
    fi\n\
  fi\n\
  if [ -f export ];then \n\
    echo ". export ..."\n\
    . export\n\
  fi \n\
fi \n\
' >> /home/yoctouser/.bashrc

# tmux user file
COPY tmux.conf /home/yoctouser/.tmux.conf
RUN chown yoctouser:yoctouser -R /home/yoctouser/.tmux.conf


# to make dirs owned by yoctouser, create and set permissions
RUN mkdir --parent /yocto/build/conf
RUN mkdir --parent /yocto/layers
RUN mkdir /yocto-deploy
RUN mkdir /yocto-downloads
RUN mkdir /yocto-sstate
RUN mkdir /yocto-tmp
RUN mkdir /yocto-layers

RUN chown yoctouser:yoctouser -R /yocto
RUN chown yoctouser:yoctouser -R /yocto-deploy
RUN chown yoctouser:yoctouser -R /yocto-downloads
RUN chown yoctouser:yoctouser -R /yocto-sstate
RUN chown yoctouser:yoctouser -R /yocto-tmp
RUN chown yoctouser:yoctouser -R /yocto-layers

WORKDIR /yocto

# change user to yoctouser
USER yoctouser


CMD ["sleep", "infinity"]
