# 
# Build docker image
#

NAME=qgis-build-deps

BUILDID=$(shell date +"%Y%m%d%H%M")
COMMITID=$(shell git rev-parse --short HEAD)

VERSION=1.1

ifdef REGISTRY_URL
REGISTRY_PREFIX=$(REGISTRY_URL)/
BUILD_ARGS += --build-arg REGISTRY_PREFIX=$(REGISTRY_PREFIX)
endif

BUILDIMAGE=$(NAME):$(VERSION)-$(COMMITID)
ARCHIVENAME=$(shell echo $(NAME):$(VERSION)|tr '[:./]' '_')

all:
	@echo "Usage: make [build|archive|deliver|clean]"

manifest:
	echo name=$(NAME) > factory.manifest && \
    echo version=$(VERSION)   >> factory.manifest && \
    echo buildid=$(BUILDID)   >> factory.manifest && \
    echo commitid=$(COMMITID) >> factory.manifest && \
    echo archive=$(ARCHIVENAME) >> factory.manifest 

build: manifest
	docker build --rm --force-rm --no-cache $(BUILD_ARGS) -t $(BUILDIMAGE) .

test:
	@echo No tests defined !

archive:
	docker save $(BUILDIMAGE) | bzip2 > $(FACTORY_ARCHIVE_PATH)/$(ARCHIVENAME).bz2

tag:
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):$(VERSION)
	docker tag $(BUILDIMAGE) $(REGISTRY_PREFIX)$(NAME):latest

deliver:
	docker push $(REGISTRY_URL)/$(NAME):$(VERSION)
	docker push $(REGISTRY_URL)/$(NAME):latest

clean:
	docker rmi -f $(shell docker images $(BUILDIMAGE) -q)
    


