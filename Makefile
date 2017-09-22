# 
# Build docker image
#

NAME=qgis3-build-deps

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

VERSION=1.0
VERSION_SHORT=1

VERSION_TAG=$(VERSION)

ifdef REGISTRY_URL
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)
endif

BUILDIMAGE=$(NAME):$(VERSION_TAG)-$(COMMITID)
ARCHIVENAME=$(shell echo $(NAME):$(VERSION_TAG)|tr '[:./]' '_')

all:
	@echo "Usage: make [build|archive|deliver|clean]"

manifest:
	echo name=$(NAME) > build.manifest && \
    echo version=$(VERSION)   >> build.manifest && \
    echo buildid=$(BUILDID)   >> build.manifest && \
    echo commitid=$(COMMITID) >> build.manifest

build: manifest
	docker build --rm --force-rm --no-cache $(BUILD_ARGS) -t $(BUILDIMAGE) .

test:
	@echo No tests defined !

archive:
	docker save $(BUILDIMAGE) | bzip2 > $(FACTORY_ARCHIVE_PATH)/$(ARCHIVENAME).bz2

deliver:
	docker tag $(BUILDIMAGE) $(REGISTRY_URL)/$(NAME):$(VERSION)
	docker tag $(BUILDIMAGE) $(REGISTRY_URL)/$(NAME):$(VERSION_SHORT)
	docker tag $(BUILDIMAGE) $(REGISTRY_URL)/$(NAME):latest
	docker push $(REGISTRY_URL)/$(NAME):$(VERSION)
	docker push $(REGISTRY_URL)/$(NAME):$(VERSION_SHORT)
	docker push $(REGISTRY_URL)/$(NAME):latest

clean:
	docker rmi -f $(shell docker images $(BUILDIMAGE))
    


