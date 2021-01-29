#!/usr/bin/env bash

# Run docker interactively in the current directory

function flags()
{
    while test $# -gt 0
    do
        case "$1" in
        (--with-gui)
            with_gui=yes
            shift;;
        (*)
            build_target=$1    
            shift;;
        esac
    done
}

flags "$@"

BUILDER=qgis-builder:${build_target:-20.04}

echo "Builder is $BUILDER"

USERID=${USERID:-$(id -u)}
GROUPID=${GROUPID:-$(id -g)}

if [[ "$with_gui" == "yes" ]]; then

echo "Running with gui supports"

# Redefine this you have a different Postgresql installation 
PG_RUN=${PG_RUN:-/var/run/postgresql}

# Set default values for PG service files
PGSERVICEFILE=${PGSERVICEFILE:-/home/$USER/.pg_service.conf}
PGPASSFILE=${PGPASSFILE:-/home/$USER/.pgpass}
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
    $BUILDER
else
docker run -it --rm -u $USERID:$GROUPID --net host \
    -v $(pwd):/home/$USER \
    --workdir /home/$USER \
    -e HOME=/home/$USER \
    --hostname=qgis-build \
    $BUILDER
fi

