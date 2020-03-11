#!/bin/bash

set -xe

BUILD_THREADS=${BUILD_THREADS:-8}

## Clone qgis if requested
if [[ ! -z  $QGIS_CLONE ]]; then
echo "Cloning Qgis  $QGIS_CLONE"
git clone --depth 1 -b $QGIS_CLONE git://github.com/qgis/QGIS.git /build
cd /build
GIT_BRANCH=$QGIS_CLONE
else
GIT_BRANCH=$(basename `git rev-parse --abbrev-ref HEAD`)
fi

SRCDIR=$PWD

if [ "$BUILD_DEBUG" == "1" ]; then
CMAKE_OPTS+=-DWITH_DEBUG:BOOL=TRUE -DCMAKE_BUILD_TYPE=Debug
BUILD_TYPE=-debug
echo "### -----------------------"
echo "### Building DEBUG version "
echo "### -----------------------"
fi

declare $(dpkg-architecture)

export BUILDDIR=$SRCDIR/build$BUILD_TYPE-$GIT_BRANCH-$DEB_TARGET_ARCH
mkdir -p $BUILDDIR

INSTALLDIR=$SRCDIR/install-$GIT_BRANCH-$DEB_TARGET_ARCH
rm -rf $INSTALLDIR 
mkdir -p $INSTALLDIR

rm -rf $BUILDDIR/CMakeCache.txt
cd $BUILDDIR

# Configure
cmake $SRCDIR  \
    -GNinja $CMAKE_OPTS \
    -DCMAKE_CXX_FLAGS=-Wno-unknown-attributes \
    -DWITH_STAGED_PLUGINS=ON \
    -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
    -DWITH_GRASS=OFF \
    -DUSE_OPENCL=OFF \
    -DWITH_3D=OFF \
    -DSUPPRESS_QT_WARNINGS=ON \
    -DENABLE_TESTS=OFF \
    -DWITH_QSPATIALITE=OFF \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DWITH_DESKTOP=OFF \
    -DWITH_BINDINGS=ON \
    -DWITH_SERVER=ON \
    -DDISABLE_DEPRECATED=ON

# Install
ninja install -j $BUILD_THREADS |cat

cd $SRCDIR

# Make debian package
export INSTALL_PREFIX=$INSTALLDIR
export PREFIX=/usr
mkdeb.sh 


