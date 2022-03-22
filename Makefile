DOCKER_IMAGE_LATEST = unbound
DOCKER_IMAGE_VERSION = 1.15.0-p1
DOCKER_IMAGE = $(DOCKER_IMAGE_LATEST):$(DOCKER_IMAGE_VERSION)
REMOTE_LATEST_TAG := flori303/$(DOCKER_IMAGE_LATEST)
REMOTE_TAG = flori303/$(DOCKER_IMAGE)

.EXPORT_ALL_VARIABLES:

build-info:
	@echo $(DOCKER_IMAGE)

build:
	docker build --pull -t $(DOCKER_IMAGE) -t $(DOCKER_IMAGE_LATEST) .
	@$(MAKE) build-info

push: build
	docker tag $(DOCKER_IMAGE) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

push-latest: push
	docker tag ${DOCKER_IMAGE} ${REMOTE_LATEST_TAG}
	docker push ${REMOTE_LATEST_TAG}

git-tag:
	git tag $(DOCKER_IMAGE_VERSION)
	git push origin
	git push origin $(DOCKER_IMAGE_VERSION)

