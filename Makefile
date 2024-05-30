# 
# Docker image build dependencies for Qgis
#

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

# Change this to 'custom' if gdal/proj must not be installed from
# default packages
GDAL_INSTALL:=default

all:
	@echo "Usage: make [build|build-deps|clean-all]"

QGIS_VERSION:=master
QGIS_GITURL:=https://github.com/qgis/QGIS.git

BASE_IMAGE_NAME:=qgis
IMAGE_NAME:=$(BASE_IMAGE_NAME):$(QGIS_VERSION)
BUILDER_DEPS_IMAGE_NAME=qgis-build-deps:latest
BUILDER_IMAGE_NAME=qgis-builder:$(QGIS_VERSION)

DOCKERFILE=Dockerfile

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


