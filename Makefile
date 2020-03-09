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
    


