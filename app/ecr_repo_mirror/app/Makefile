SHELL := /bin/bash

# Below is the interface for the Python environment
PY_VER ?= 3.12
REQ ?= requirements/requirements
VENV_SUB ?= ecr_mirror

VER_REGEX := sed -nre 's/.*?([0-9]+\.[0-9]+)\.[0-9]+.*/\1/p'
SYS_PY_BIN := $(shell command -v python)# Go ahead and diagnose env issues now
SYS_PY_VER := $(shell $(SYS_PY_BIN) --version | $(VER_REGEX))
PYENV_ROOT ?= /usr/local/pyenv
PYENV_BIN := $(PYENV_ROOT)/versions/$(PY_VER).*/bin/python
BASE_PY_BIN := $(shell [ $(PY_VER) == $(SYS_PY_VER) ] && echo $(SYS_PY_BIN) || echo $(PYENV_BIN))
BASE_PY ?= $(BASE_PY_BIN)
VENV := .venv/$(VENV_SUB)

ACTIVATE := source "$(VENV)/bin/activate"
PIP := -m pip install --upgrade
PY := $(ACTIVATE) &&
# Pin below as things break - especially setuptools
ENV_INIT := python $(PIP) --no-cache-dir pip wheel setuptools

AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --query "Account" --output text)
AWS_REGION ?= $(shell aws configure get region)
REPO := $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com

# Below is the interface for Docker build
DOCKERFILE ?= docker/Dockerfile
ARCH ?= linux/amd64,linux/arm64
IMAGE ?= ecr-repo-mirror
TAG ?= latest

ARCH_NAME := $(shell echo $(ARCH) | sed -nre 's/[,]/_/g; s/[/]/-/gp')

DC := docker compose -f docker/docker_compose.yml

docker-builder:
	docker buildx ls | grep -q ^$(ARCH_NAME)[[:space:]] || docker buildx create --name $(ARCH_NAME) --bootstrap --platform $(ARCH)

docker-build-local:
	$(DC) build

docker-build-manifest: ecr-login
	docker buildx imagetools create -t $(REPO)/$(IMAGE):$(TAG) \
		$(REPO)/$(IMAGE):$(TAG)-amd \
		$(REPO)/$(IMAGE):$(TAG)-arm

docker-build-remote: ecr-login docker-build-remote-cred

docker-build-remote-cred: docker-builder
	docker buildx build \
	--platform $(ARCH) \
	--builder $(ARCH_NAME) \
	--progress plain \
	--file $(DOCKERFILE) \
	--cache-from $(REPO)/$(IMAGE):$(TAG) \
	--tag $(REPO)/$(IMAGE):$(TAG) \
	--push .

docker-clean:
	docker container ls -aq | xargs docker stop | xargs docker rm 2> /dev/null || true

docker-down:
	$(DC) down -v

docker-nuke: docker-clean
	docker image ls -a | xargs docker image rm 2> /dev/null || true
	docker system prune -a

docker-shell: docker-up
	docker exec -it ecr-mirror /bin/bash

docker-up: docker-build-local
	$(DC) up --detach

ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(REPO)

ecr-mirror:
	$(PY) ecr-mirror --registry-id $(AWS_ACCOUNT) sync

$(VENV):
	@echo Application Python version is \'$(PY_VER)\'
	@echo System Python binary is \'$(SYS_PY_BIN)\'
	@echo System Python version is \'$(SYS_PY_VER)\'
	@echo Pyenv binary, if needed, is \'$(PYENV_BIN)\'
	@echo Auto-detected Python binary is \'$(BASE_PY_BIN)\'
	@echo $(BASE_PY) | grep -q '*' && echo ERROR: $(BASE_PY) not found, install Python $(PY_VER) with Pyenv or override, as in BASE_PY=my/special/python make env-install && exit 1 || echo Using base Python at $(BASE_PY)
	$(BASE_PY) -m venv $(VENV)

env-clean:
	rm -rf $(VENV)

env-install: $(VENV)
	$(PY) $(ENV_INIT)
	$(PY) python $(PIP) -r $(REQ).lock.txt

env-update: $(VENV)
	$(PY) $(ENV_INIT)
	$(PY) python $(PIP) --no-cache-dir -r $(REQ).txt
	$(PY) python -m pip freeze --all > $(REQ).lock.txt
