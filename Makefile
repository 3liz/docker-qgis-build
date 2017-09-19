# 
# Build docker image
#

NAME=infra/qgis3-build-deps

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

VERSION=1.0
VERSION_SHORT=1

VERSION_TAG=$(VERSION)-$(COMMITID)

ifdef REGISTRY_URL
REGISTRY_PREFIX=$(REGISTRY_URL):
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)
endif

BUILDIMAGE=$(NAME):$(VERSION_TAG)
ARCHIVENAME=$(shell echo $(BUILDIMAGE)|tr '[:./]' '_')

manifest:
	@echo "TODO: Create manifest"

build: manifest
	docker build --rm --force-rm --no-cache $(BUILD_ARGS) -t $(BUILDIMAGE) .
	@echo $(VERSION_TAG) > .build

test:
	@echo: No tests defined !

package:
	docker save $(BUILDIMAGE) | bzip2 > $(DOCKER_ARCHIVE_PATH)/$(ARCHIVENAME).bz2

clean:
	docker rmi $(BUILDIMAGE)
    


