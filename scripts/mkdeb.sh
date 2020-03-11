#!/bin/bash

set -xe

source /etc/os-release

declare $(dpkg-architecture)

QGIS_MAJOR=`sed -ne 's/SET(CPACK_PACKAGE_VERSION_MAJOR "\([0-9]*\)")/\1/p' CMakeLists.txt`
QGIS_MINOR=`sed -ne 's/SET(CPACK_PACKAGE_VERSION_MINOR "\([0-9]*\)")/\1/p' CMakeLists.txt`
QGIS_PATCH=`sed -ne 's/SET(CPACK_PACKAGE_VERSION_PATCH "\([0-9]*\)")/\1/p' CMakeLists.txt`

QGIS_VERSION=${QGIS_VERSION:-"$QGIS_MAJOR.$QGIS_MINOR.$QGIS_PATCH"}

PREFIX=${PREFIX:-"/usr/"}
PKGVERSION=$QGIS_VERSION~$DEB_TARGET_ARCH-$VERSION_CODENAME
PKGNAME=qgis-3liz

mkdir -p $BUILDDIR/debian/$PREFIX 
mkdir -p $BUILDDIR/debian/DEBIAN
cp -aR $INSTALL_PREFIX/* $BUILDDIR/debian/$PREFIX/

# Remove include files
rm -r $BUILDDIR/debian/$PREFIX/include

cat > $BUILDDIR/debian/DEBIAN/postinst <<EOF1
#!/bin/sh
ldconfig $PREFIX/lib
EOF1

chmod 755 $BUILDDIR/debian/DEBIAN/postinst

WITH_3D=`sed -ne 's/WITH_3D:BOOL=\(TRUE\|ON\)/\1/p' $BUILDDIR/CMakeCache.txt`
WITH_OPENCL=`sed -ne 's/USE_OPENCL:BOOL=\(TRUE\|ON\)/\1/p' $BUILDDIR/CMakeCache.txt`

[ ! -z $WITH_3D ] && DEPENDS_OPTS="-D WITH_3D"
[ ! -z $WITH_OPENCL ] && DEPENDS_OPTS="$DEPENDS_OPTS -D WITH_OPENCL"

gpp /usr/local/bin/pkg-depends.in $DEPENDS_OPTS  \
 -D VERSION_CODENAME=$VERSION_CODENAME > pkg-depends

DEPENDS=($(cat pkg-depends))

cat > $BUILDDIR/debian/DEBIAN/control  <<EOF2
Package: $PKGNAME 
Version: $PKGVERSION 
Section: science
Priority: optional
Architecture: $DEB_TARGET_ARCH
Maintainer: 3liz <info@3liz.com> 
Description: Qgis distribution - 3liz custom build
Conflicts: qgis, python3-qgis, python3-qgis-common, qgis-providers, qgis-providers-common, qgis-server
Depends: ${DEPENDS[@]}
EOF2

FULLPKGNAME=./$PKGNAME-$PKGVERSION.deb

fakeroot dpkg-deb --build $BUILDDIR/debian ./$FULLPKGNAME
echo $FULLPKGNAME > .PKG_MANIFEST

if [ ! -z $EXPORT_USER ] && 
    chown $EXPORT_USER: $FULLPKGNAME .PKG_MANIFEST
fi

if [ ! -z $EXPORT_DIR ]; then
    mv ./$FULLPKGNAME .PKG_MANIFEST $EXPORT_DIR/
fi


