DOCKER_USER = flori303
DOCKER_IMAGE_NAME = unbound
DOCKER_IMAGE_VERSION = ${GITHUB_REF_NAME}

.EXPORT_ALL_VARIABLES:

build:
	docker buildx rm unbound-builder || true
	docker buildx create --name unbound-builder
	docker buildx use unbound-builder
	docker buildx inspect --bootstrap
	docker buildx build --platform linux/amd64,linux/arm64 --pull --push -t $(DOCKER_USER)/$(DOCKER_IMAGE_NAME) -t $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) .
	docker buildx use default

git-tag:
	git tag $(DOCKER_IMAGE_VERSION)
	git push origin
	git push origin $(DOCKER_IMAGE_VERSION)

