#!/usr/bin/env bash

# Run docker interactively in the current directory

USERID=${USERID:-$(id -u)}
GROUPID=${GROUPID:-$(id -g)}

# Redefine this you have a different Postgresql installation 
PG_RUN=${PG_RUN:-/var/run/postgresql}

docker run -it --rm -u $USERID:$GROUPID --net host \
    -e HOME=/home/$USER \
    -e DISPLAY=unix$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e PGSERVICEFILE=$PGSERVICEFILE \
    -e PGPASSFILE=$PGPASSFILE \
    -v $HOME:/home/$USER \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $PG_RUN:/var/run/postgresql \
    --workdir $(pwd) \
    --hostname=qgis-build \
    --privileged \
    --device /dev/dri \
    qgis-build-deps:${1:-bionic}

