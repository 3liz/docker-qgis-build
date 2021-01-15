#!/usr/bin/env bash

set -ex

PACKAGE=$1
TAG=$2
BUILDIMAGE=qgis-build-install:$TAG

cp -v $PACKAGE  ./

docker build --rm --build-arg PACKAGE=$(basename $PACKAGE)  \
             -t $BUILDIMAGE  -f Dockerfile.install .




