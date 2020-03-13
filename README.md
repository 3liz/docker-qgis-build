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

ARM builds use the [balenalib base images](https://www.balena.io/docs/reference/base-images/base-images/) for cross building Qgis.


### Building dependencies

For building dependencies image for a specific distribution, pass the name and the version codename of the distribution as
parameters:

Example for building dependencies for arm32 on debian buster: 
```
make arm32-deps OS_DIST_TARGET=debian OS_DIST_VERSION=buster
```

### Build Qgis interactively

Use the script `qgis-build-env-arm.sh`. 

It is the same as the `qgis-build-env.sh` script but run as
root because of the way Qemu  is executed  the balena images does not run commands 
interactively as user other than root.


see also:
    * [balenalib base images references](https://www.balena.io/docs/reference/base-images/base-images-ref/)


