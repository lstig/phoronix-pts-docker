.ONESHELL:
SHELL = /bin/bash

IMAGE_REGISTRY := ghcr.io
IMAGE_NAME     := lstig/pts
BUILD_REF      != git rev-parse --short HEAD
VERSION        != cd phoronix-test-suite && ./phoronix-test-suite version 2>/dev/null | grep '^Phoronix Test Suite v' | cut -d' ' -f4
PROJECT_DIR    != git rev-parse --show-toplevel
BUILD_ROOT     := $(PROJECT_DIR)/build
BASE_DIR       := $(BUILD_ROOT)/base
PLATFORMS      ?= $(shell docker system info --format '{{.OSType}}/{{.Architecture}}')

export PTS_USER_PATH_OVERRIDE              := $(BASE_DIR)/var/lib/phoronix-test-suite/
export PTS_DOWNLOAD_CACHE_OVERRIDE         := $(BASE_DIR)/var/cache/phoronix-test-suite/download-cache/
export PTS_DOWNLOAD_CACHING_PLATFORM_LIMIT := 1

DIRS := $(BUILD_ROOT) $(BASE_DIR) $(PTS_USER_PATH_OVERRIDE) $(PTS_DOWNLOAD_CACHE_OVERRIDE)

.PHONY: submodule-init
submodule-init:
	git submodule update --init --recursive --remote

.PHONY: build
build: $(BUILD_ROOT)/base.tar.xz
	docker build \
		--label org.opencontainers.image.base.digest="unkown" \
		--label org.opencontainers.image.revision=$(BUILD_REF) \
		--label org.opencontainers.image.created=$$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
		--label org.opencontainers.image.version=$(VERSION) \
		--platform $(PLATFORMS) \
		--tag ${IMAGE_REGISTRY}/${IMAGE_NAME}:$(BUILD_REF) .

.PHONY: release
release:
	for tag in $(VERSION) latest; do
		docker tag docker tag ${IMAGE_REGISTRY}/${IMAGE_NAME}:$(BUILD_REF) ${IMAGE_REGISTRY}/${IMAGE_NAME}:$${tag}
		docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:$${tag}
	done

.PHONY: clean
clean:
	@rm -rf "$(BUILD_ROOT)"

$(DIRS):
	@mkdir -p "$@"

$(BUILD_ROOT)/base.tar.xz: | $(DIRS)
	git clone --local "$(PROJECT_DIR)/phoronix-test-suite" "$(BASE_DIR)/phoronix-test-suite"
	rm -rf "$(BASE_DIR)/phoronix-test-suite/.git"
	cd "$(BASE_DIR)/phoronix-test-suite"
	./phoronix-test-suite make-openbenchmarking-cache lean
	rm -f "$(PTS_USER_PATH_OVERRIDE)/core.pt2so"
	tar cfJ "$@" -C "$(BASE_DIR)" .
