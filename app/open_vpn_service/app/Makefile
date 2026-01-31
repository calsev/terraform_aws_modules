# This file is managed with Terraform!
SHELL := /bin/bash

ARCH ?= linux/amd64,linux/arm64

ARCH_NAME := $(shell echo $(ARCH) | sed -nre 's/[,]/_/g; s/[/]/-/gp')
DC := docker compose -f docker/docker_compose.yml
IMAGE := openvpn-server

docker-builder:
	docker buildx ls | grep -q ^$(ARCH_NAME)[[:space:]] || docker buildx create --name $(ARCH_NAME) --bootstrap --platform $(ARCH)

docker-build-local: ecr-login
	$(DC) build

docker-build-manifest: ecr-login
	docker buildx imagetools create -t ${ecr_repo_url}:${image_tag_base} \
		$(shell [[ "$$ARCH" == *'/amd64'* ]] && echo ${ecr_repo_url}:${image_tag_base}-amd || echo '') \
		$(shell [[ "$$ARCH" == *'/arm64'* ]] && echo ${ecr_repo_url}:${image_tag_base}-arm || echo '')

docker-build-remote: ecr-login docker-builder
	docker buildx build \
	--platform $(ARCH) \
	--builder $(ARCH_NAME) \
	--progress plain \
	--file docker/Dockerfile \
	--target remote \
	--cache-from ${ecr_repo_url}:${image_tag_base} \
	--tag ${ecr_repo_url}:${image_tag_base} \
	--push .

docker-clean:
	docker container ls -aq | xargs docker stop | xargs docker rm 2> /dev/null || true

docker-down:
	$(DC) down -v

docker-log:
	docker logs --follow $(IMAGE)

docker-shell: docker-up
	docker exec -it $(IMAGE) /bin/bash

docker-up: docker-build-local
	$(DC) up --detach

ecr-login:
	aws ecr get-login-password --region ${aws_region_name} | docker login --username AWS --password-stdin ${ecr_repo_url}:
