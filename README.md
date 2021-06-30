# Qgis build environment

Create an image with qgis build dependencies for building and running tests in
a Docker container from sources.

## Building qgis

```
make build 
```

By default, create a multi-stage build environment for ubuntu 20.04.

To build another environment use the `TARGET` variable, the dockerfile `Dockerfile.<target>` must exists:

To build a specific version (branch/tag) of Qgis, use the `QGIS_VERSION` variable:

Example
```
make build QGIS_VERSION=release-3_10
```

## Building qgis interactively

Make sure that the `build-deps` image is builded:

```
make build-deps [TARGET=<target>]
```

You must clone the qgis repository locally then cd into it. Then run the `qgis-build-env.sh` script.

The script open a bash session interactively in the `build-deps` image, from it you may run any build command exactly
the same way as usual to build test and run Qgis.






