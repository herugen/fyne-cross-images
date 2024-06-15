include Makefile.inc

.PHONY: all base darwin darwin-sdk-extractor linux windows

# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base: .base
.base: base/Dockerfile
	@$(RUNNER) build -f ${CURDIR}/base/Dockerfile -t ${REPOSITORY}:${VERSION}-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:base
	@touch .base

darwin: .darwin
.darwin: .base darwin/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/darwin/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin ${REPOSITORY}:darwin
	@touch .darwin

linux: .linux
.linux: .base linux/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/linux/Dockerfile -t ${REPOSITORY}:${VERSION}-linux .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-linux ${REPOSITORY}:linux
	@touch .linux

windows: base
    # windows image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:${VERSION}-windows
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-windows ${REPOSITORY}:windows

all: base darwin linux windows

base-pull:
	@$(RUNNER) pull ${REPOSITORY}:${VERSION}-base
	touch .base