DOCKER_IMAGE_LATEST = unbound
DOCKER_IMAGE_VERSION = 1.11.0-p1
DOCKER_IMAGE = $(DOCKER_IMAGE_LATEST):$(DOCKER_IMAGE_VERSION)
REMOTE_LATEST_TAG := flori303/$(DOCKER_IMAGE_LATEST)
REMOTE_TAG = flori303/$(DOCKER_IMAGE)

.EXPORT_ALL_VARIABLES:

build-info:
	@echo $(DOCKER_IMAGE)

build:
	git tag $(DOCKER_IMAGE_VERSION)
	docker build -t $(DOCKER_IMAGE) -t $(DOCKER_IMAGE_LATEST) .
	@$(MAKE) build-info