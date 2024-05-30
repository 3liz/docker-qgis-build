#!/usr/bin/env bash

set -x

# Run docker interactively in the current directory

function flags()
{
    while test $# -gt 0
    do
        case "$1" in
        (--run)
            run_qgis=yes
            install_dir=$2
            shift 2;;
        esac
    done
}

flags "$@"

BUILDER=qgis-build-deps

echo "Builder is $BUILDER"

USERID=${USERID:-$(id -u)}
GROUPID=${GROUPID:-$(id -g)}

if [[ "$run_qgis" == "yes" ]]; then

echo "Running Qgis from installation directory"

# Redefine this you have a different Postgresql installation 
PG_RUN=${PG_RUN:-/var/run/postgresql}

# Set default values for PG service files
PGSERVICEFILE=${PGSERVICEFILE:-/home/$USER/.pg_service.conf}
PGPASSFILE=${PGPASSFILE:-/home/$USER/.pgpass}
docker run -it --rm --net host \
    -e QGIS_USER=$USERID \
    -e QGIS_GROUP=$GROUPID \
    -e USER=$USER \
    -e HOME=/home/$USER \
    -e DISPLAY=unix$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e QT_DEBUG_PLUGINS=1 \
    -e PGSERVICEFILE=$PGSERVICEFILE \
    -e PGPASSFILE=$PGPASSFILE \
    --mount type=bind,source=$HOME,target=/home/$USER \
    --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
    --mount type=bind,source=$PG_RUN,target=/var/run/postgresql \
    --mount type=bind,source=$install_dir,target=/qgis-install \
    --name qgis-build-env \
    --workdir $(pwd) \
    --hostname=qgis-build-run \
    --entrypoint=run-docker-entrypoint.sh \
    $DOCKER_EXTRA_OPTS $BUILDER qgis
else
docker run -it --rm -u $USERID:$GROUPID --net host \
    --mount type=bind,source=$(pwd),target=/home/$USER \
    --workdir /home/$USER \
    -e HOME=/home/$USER \
    --hostname=qgis-build \
    --name qgis-build-env \
    $DOCKER_EXTRA_OPTS $BUILDER
fi

