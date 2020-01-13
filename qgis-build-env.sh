#!/usr/bin/env bash

# Run docker interactively in the current directory

docker run -it --rm -u $(id -u):$(id -g) \
    -v $(pwd):/home/$USER \
    --workdir /home/$USER \
    -e HOME=/home/$USER \
    --hostname=qgis-build \
    qgis-build-deps:${1:-bionic}

