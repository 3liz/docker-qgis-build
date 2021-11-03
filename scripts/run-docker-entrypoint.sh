#!/bin/bash

set -x

ldconfig /qgis-install/lib
ln -sf /qgis-install/share/qgis/python/qgis /usr/lib/python3/dist-packages/qgis

export PATH=$PATH:/qgis-install/bin

groupadd --gid $QGIS_GROUP qgis
useradd --gid $QGIS_GROUP --uid $QGIS_USER --home-dir $HOME --no-create-home $USER

gosu $USER "$@"

