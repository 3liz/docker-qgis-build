# Qgis build environment

Create an image with qgis build dependencies for building and running tests in
a Docker container from sources.

## Building the base image

```
make build 
```

By default, create en build environment for ubuntu 18.04 bionic.

To build another environment use the `IMAGE` and `VERSION` variables:

```
make build VERSION=buster IMAGE=debian:buster-slim
```

## Building qgis

cd into your qgis source repository then run the `qgis-build-env.sh`. The script start 
an interactive bash session in a Docker container from where you can run build commands


## Building qgis debian package

You must be in your build environment in order to create the debian package.

First install qgis in a custom location - defined by the `CMAKE_INSTALL_PREFIX` variables. Then
run the `mkdeb.sh` command:

```
BUILDDIR=<build_dir> INSTALL_PREFIX=<install_prefix> PREFIX='/usr' mkdeb.sh
```

## Building for ARM

1. Get the [balenalib debian buster base image](https://hub.docker.com/r/balenalib/armv7hf-debian)

```
docker pull balenalib/armv7hf-debian:buster-build
```

Références:

* https://hub.docker.com/u/balenalib/arvmv
* https://www.balena.io/docs/reference/base-images/base-images/



