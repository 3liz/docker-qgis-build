# Qgis build helper

#!/bin/bash

set -x
set -e

## The following options are
## Defined as build arguments in Dockerfiles

#BUILD_THREADS=${BUILD_THREADS:-8}
#WITH_DESKTOP=${WITH_DESKTOP:-ON}
#WITH_GRASS=${WITH_GRASS:-OFF}
#USE_OPENCL=${USE_OPENCL:-OFF}
#WITH_3D=${WITH_3D:-OFF}
#ENABLE_TESTS=${ENABLE_TESTS:-OFF}

mkdir -p /build/release
cd /build/release

if [ "$BUILD_DEBUG" == "1" ]; then
CMAKE_OPTS="$CMAKE_OPTS -DCMAKE_BUILD_TYPE=Debug"
echo "### -----------------------"
echo "### Building DEBUG version "
echo "### -----------------------"
fi

CMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS -Wno-unknown-attributes"

if [ ! -z $PROJ_LIBRARY ]; then
CMAKE_OPTS="$CMAKE_OPTS -DPROJ_LIBRARY:FILEPATH=$PROJ_LIBRARY"
CMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS -DPROJ_RENAME_SYMBOLS -DPROJ_INTERNAL_CPP_NAMESPACE"
fi

INSTALL_PREFIX=/qgis-install

cmake -GNinja $CMAKE_OPTS \
    -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" \
    -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_PREFIX \
    -DWITH_STAGED_PLUGINS=ON \
    -DSUPPRESS_QT_WARNINGS=ON \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_3D:BOOL=$WITH_3D \
    -DWITH_GRASS:BOOL=$WITH_GRASS \
    -DUSE_OPENCL:BOOL=$USE_OPENCL \
    -DENABLE_TESTS:BOOL=$ENABLE_TESTS \
    -DWITH_DESKTOP:BOOL=$WITH_DESKTOP \
    -DWITH_ASTYLE=OFF \
    -DWITH_APIDOC=OFF \
    -DWITH_SERVER=ON \
    -DQSCI_SIP_DIR=/usr/share/sip/PyQt5/Qsci \
    /build/QGIS

mkdir -p $INSTALL_PREFIX
ninja install -j $BUILD_THREADS |cat

