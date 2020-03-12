# 
# Docker image build dependencies based
# on ubuntu:bionic
#

NAME=qgis-build-deps


BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

VERSION:=bionic
IMAGE:=ubuntu:bionic

BUILD_ARGS=--build-arg="IMAGE=$(IMAGE)"

BUILDIMAGE=$(NAME):$(VERSION)-$(COMMITID)

all:
	@echo "Usage: make [build|clean|clean-all]"


build:
	docker build --rm $(BUILD_ARGS) -t $(BUILDIMAGE) \
		-t $(NAME):$(VERSION) --cache-from $(NAME):$(VERSION) .

clean:
	docker rmi $(BUILDIMAGE)

clean-all:
	docker rmi -f $(shell docker images $(BUILDIMAGE) -q)

#
# Default qgis branch to build
# May be specified on command line
#
QGIS_BRANCH:=final-3_10_3

#------------
# arm 32 bits
#------------
ARM32_VERSION:=armv7hf-buster
ARM32_BASE_IMAGE=armv7hf-debian:buster

arm32-deps:
	$(MAKE) arm-build-deps \
		ARM_BUILDIMAGE=$(NAME):$(ARM32_VERSION) \
		ARM_BASE_IMAGE=$(ARM32_BASE_IMAGE)

arm32-build:
	$(MAKE) arm-build \
		ARM_VERSION=$(ARM32_VERSION) \
		ARM_BUILDIMAGE=$(NAME):$(ARM32_VERSION) \
		ARM_BASE_IMAGE=$(ARM32_BASE_IMAGE)


#------------
# arm 64 bits
#------------
ARM64_VERSION=aarch64-buster
ARM64_BASE_IMAGE=aarch64-debian:buster

arm64-deps:
	$(MAKE) arm-build-deps \
		ARM_BUILDIMAGE=$(NAME):$(ARM64_VERSION) \
		ARM_BASE_IMAGE=$(ARM64_BASE_IMAGE)

arm64-build:
	$(MAKE) arm-build \
		ARM_BUILDIMAGE=$(NAME):$(ARM64_VERSION) \
		ARM_BASE_IMAGE=$(ARM64_BASE_IMAGE)


arm-build-deps:
ifdef REGISTRY_PREFIX
	docker pull $(REGISTRY_PREFIX)$(ARM_BUILDIMAGE) || true
endif
	docker build --rm -t $(ARM_BUILDIMAGE) --cache-from $(REGISTRY_PREFIX)$(ARM_BUILDIMAGE) \
		--build-arg="ARM_BASE_IMAGE=$(ARM_BASE_IMAGE)" \
	-f Dockerfile.arm .
ifdef REGISTRY_PREFIX
	docker tag  $(ARM_BUILDIMAGE) $(REGISTRY_PREFIX)$(ARM_BUILDIMAGE)
	docker push $(REGISTRY_PREFIX)$(ARM_BUILDIMAGE)
endif

BUILDDIR=$(PWD)/build

arm-build: arm-build-deps
	rm -rf $(BUILDDIR)/*  
	mkdir -p $(BUILDDIR)
	docker run --rm -v $(BUILDDIR):/export.d \
		-e EXPORT_USER=$(USER) \
		-e EXPORT_DIR=/export.d \
		-e QGIS_CLONE=$(QGIS_BRANCH) \
		$(REGISTRY_PREFIX)$(ARM_BUILDIMAGE) build-arm.sh

.PHONY: package
package:
	@echo "Building package $(FACTORY_PACKAGE_NAME)"
	{ set -e; source $(BUILDDIR)/.PKG_MANIFEST; \
	  $(FACTORY_SCRIPTS)/make-packages $(FACTORY_PACKAGE_NAME) $(PKG_VERSION) $(PKG_FILE); \
	}

