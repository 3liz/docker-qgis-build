# 
# Docker image build dependencies based
# on ubuntu:bionic
#

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

TARGET:=focal

# Change this to 'custom' if gdal/proj must no be installed from
# default packages
GDAL_INSTALL:=default

all:
	@echo "Usage: make [build|build-deps|clean-all]"

QGIS_VERSION:=master
QGIS_GITURL:=git://github.com/qgis/QGIS.git

BASE_IMAGE_NAME:=qgis
IMAGE_NAME:=$(BASE_IMAGE_NAME):$(QGIS_VERSION)-$(TARGET)
BUILDER_DEPS_IMAGE_NAME=qgis-build-deps:$(TARGET)
BUILDER_IMAGE_NAME=qgis-builder:$(QGIS_VERSION)-$(TARGET)

DOCKERFILE=Dockerfile.$(TARGET)

BUILD_ARGS=\
  --build-arg="QGIS_VERSION=$(QGIS_VERSION)" \
  --build-arg="QGIS_GITURL=$(QGIS_GITURL)" \
  --build-arg="GDAL_INSTALL=$(GDAL_INSTALL)"

build-deps: 
	docker build $(BUILD_ARGS) --target builddeps -t "$(BUILDER_DEPS_IMAGE_NAME)" -f $(DOCKERFILE) .

build: build-deps
	docker build $(BUILD_ARGS) --target builder -t "$(BUILDER_IMAGE_NAME)" -f $(DOCKERFILE) .
	docker build $(BUILD_ARGS) -t $(IMAGE_NAME) -f $(DOCKERFILE) .

# Special rule for gdal custom build
build-gdal: builder
	$(MAKE) build TARGET=gdal GDAL_INSTALL=custom

clean-all:
	docker rmi -f $(shell docker images  $(NAME):$(VERSION) -q)


