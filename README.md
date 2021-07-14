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
make build QGIS_VERSION=master
```

## Building qgis interactively

Make sure that the `build-deps` image is builded:

```
make build-deps [TARGET=<target>]
```

You must clone the qgis repository locally then cd into it. Then run the `qgis-build-env.sh` script.

The script open a bash session interactively in the `build-deps` image, from it you may run any build command exactly
the same way as usual to build test and run Qgis.

By default, the built image will have its `version_tag` set to `<QGIS_VERSION>-<TARGET`.  Exemple: if you have choosen
`QGIS_VERSION=final-3_10_14` as qgis version to build, the final image will tagged `qgis:final-3_10_14-ubuntu` 

## Runnig Qgis desktop

Use the script `qgis-run`:

```
FLAVOR=<version_tag> qgis-run
```

