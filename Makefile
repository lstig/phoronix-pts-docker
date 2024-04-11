.ONESHELL:
SHELL = /bin/bash

IMAGE_REGISTRY := ghcr.io
IMAGE_NAME     := lstig/pts
BUILD_REF      != git rev-parse --short HEAD
VERSION        != cd phoronix-test-suite && ./phoronix-test-suite version 2>/dev/null | grep '^Phoronix Test Suite v' | cut -d' ' -f4
PLATFORMS      ?= $(shell docker system info --format '{{.OSType}}/{{.Architecture}}')

BASE_REGISTRY     := public.ecr.aws
BASE_IMAGE        := $(BASE_REGISTRY)/ubuntu/ubuntu:22.04
BASE_IMAGE_DIGEST := sha256:d06a58cbb8c28143d504b4fa83e93b516e570582fb961b300ff3562383429d4d

.PHONY: submodule-init
submodule-init:
	git submodule update --init --recursive --remote

.PHONY: build
build:
	docker build \
		--label org.opencontainers.image.base.name="$(BASE_IMAGE)" \
		--label org.opencontainers.image.base.digest="$(BASE_IMAGE_DIGEST)" \
		--label org.opencontainers.image.revision=$(BUILD_REF) \
		--label org.opencontainers.image.created=$$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
		--label org.opencontainers.image.version=$(VERSION) \
		--build-arg=BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg=BASE_IMAGE_DIGEST=$(BASE_IMAGE_DIGEST) \
		--platform $(PLATFORMS) \
		--tag ${IMAGE_REGISTRY}/${IMAGE_NAME}:$(BUILD_REF) .

.PHONY: release
release:
	for tag in $(VERSION) latest; do
		docker tag docker tag ${IMAGE_REGISTRY}/${IMAGE_NAME}:$(BUILD_REF) ${IMAGE_REGISTRY}/${IMAGE_NAME}:$${tag}
		docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:$${tag}
	done

.PHONY: outputs
outputs:
	@echo "PTS_VERSION=$(VERSION)"
	@echo "BUILD_TIME=$$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
	@echo "BASE_IMAGE=$(BASE_IMAGE)"
	@echo "BASE_IMAGE_DIGEST=$(BASE_IMAGE_DIGEST)"

.PHONY: version
version:
	@echo "$(VERSION)"
