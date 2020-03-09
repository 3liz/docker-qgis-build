#!/usr/bin/env bash

# Run docker interactively in the current directory

USERID=${USERID:-$(id -u)}
GROUPID=${GROUPID:-$(id -g)}

docker run -it --rm -u $USERID:$GROUPID --net host \
    -v $(pwd):/home/$USER \
    --workdir /home/$USER \
    -e HOME=/home/$USER \
    --hostname=qgis-build \
    qgis-build-deps:${1:-bionic}

