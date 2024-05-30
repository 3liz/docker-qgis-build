#
# Makefile for building Qgis on Linux
#
.PHONY: build install clean clobber

CMAKE_OPTS:=

BUILD_THREADS:=12

WITH_DESKTOP:=ON
WITH_GRASS:=OFF
USE_OPENCL:=OFF
WITH_3D:=OFF
ENABLE_TESTS:=ON

GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)


ifeq ($(QGIS_DEBUG),1)
BUILDDIR=build-$(GIT_BRANCH)-debug
CMAKE_OPTS+=-DWITH_DEBUG:BOOL=TRUE -DCMAKE_BUILD_TYPE=Debug
else
BUILDDIR=build-$(GIT_BRANCH)
endif

INSTALL_PREFIX:=$(PWD)/$(BUILDDIR)/.install

CMAKE_CXX_FLAGS=-Wno-unknown-attributes

ifdef PROJ_LIBRARY
CMAKE_OPTS+=-DPROJ_LIBRARY:FILEPATH=$(PROJ_LIBRARY)
CMAKE_CXX_FLAGS+=-DPROJ_RENAME_SYMBOLS -DPROJ_INTERNAL_CPP_NAMESPACE
endif

configure:
	@echo "Install prefix is $(INSTALL_PREFIX)"
	mkdir -p $(BUILDDIR)
	rm -rf $(BUILDDIR)/CMakeCache.txt
	cd $(BUILDDIR) && cmake -GNinja $(CMAKE_OPTS) \
    -DCMAKE_CXX_FLAGS="$(CMAKE_CXX_FLAGS)" \
    -DCMAKE_INSTALL_PREFIX:PATH=$(INSTALL_PREFIX) \
    -DWITH_STAGED_PLUGINS=ON \
    -DSUPPRESS_QT_WARNINGS=ON \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_3D:BOOL=$(WITH_3D) \
    -DWITH_GRASS:BOOL=$(WITH_GRASS) \
    -DUSE_OPENCL:BOOL=$(USE_OPENCL) \
    -DENABLE_TESTS:BOOL=$(ENABLE_TESTS) \
    -DWITH_DESKTOP:BOOL=$(WITH_DESKTOP) \
    -DWITH_ASTYLE=ON \
    -DWITH_APIDOC=OFF \
    -DWITH_SERVER=ON \
    -DQSCI_SIP_DIR=/usr/share/sip/PyQt5/Qsci \
    ..


build:
	cd $(BUILDDIR) && ninja -j $(BUILD_THREADS) |cat

install:
	mkdir -p $(INSTALL_PREFIX)
	cd $(BUILDDIR) && ninja install -j $(BUILD_THREADS) |cat
	@echo installation directory is: $(INSTALL_PREFIX) 

clean-install:
	rm -r $(INSTALL_PREFIX)

clobber:
	ccache -C
	rm -rf $(BUILDDIR) 

test: 
	cd $(BUILDDIR) && ctest $(TEST_OPTS)

touch:
	touch src/server/*.cpp
	touch src/server/services/*/*.cpp
	touch python/server/server.sip

package: 
	export BUILDDIR=$(BUILDDIR) &&\
	export INSTALLDIR=$(INSTALL_PREFIX) &&\
	export PREFIX=/usr &&\
	mkdeb.sh 

prepare:
	scripts/prepare_commit.sh

