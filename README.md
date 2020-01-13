# Qgis build environment

Create an image with  qgis build dependencies for building and running tests in
o Docker container

## Building qgis

cd into your qgis source repository then run the `qgis-build-env.sh`. The script start 
an interactive bash session in a Docker container from where you can run build commands

## Credits

The Dockerfile is derived from the original [Qgis docker branch](https://github.com/qgis/QGIS/blob/docker/.docker/Dockerfile)

