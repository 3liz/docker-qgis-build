# Docker build dependencies

Create an image based on debian/stretch for qgis build dependencies.

## Running as a standalone container

If the image is run as a standalone container the src directory should be bind-mounted in /root/src.

The default command (CMD) is to execute the file /root/src/docker-build-test.sh 

## Credits

The Dockerfile is derived from the original [Qgis docker branch](https://github.com/qgis/QGIS/blob/docker/.docker/Dockerfile)

