SHELL := /bin/bash

REQ := requirements/requirements
VER_REGEX := sed -nre 's/.*?([0-9]+\.[0-9]+)\.[0-9]+.*/\1/p'
PY_VER := $(shell echo 3.10.0 | $(VER_REGEX)) # echo/cat/grep/? to get version from wherever
SYS_PY_BIN := $(shell command -v python) # Go ahead and diagnose env issues now
SYS_PY_VER := $(shell $(SYS_PY_BIN) --version | $(VER_REGEX))
PYENV_ROOT ?= /usr/local/pyenv
PYENV_BIN := $(PYENV_ROOT)/versions/$(PY_VER)*/bin/python
BASE_PY_BIN := $(shell [ $(PY_VER) == $(SYS_PY_VER) ] && echo $(SYS_PY_BIN) || echo $(PYENV_BIN))
BASE_PY ?= $(BASE_PY_BIN)
VENV := .venv

ACTIVATE := source "$(VENV)/bin/activate"
PIP := -m pip install --upgrade
PY := $(ACTIVATE) &&
# Pin below as things break - especially setuptools
PY_INIT := $(PIP) --no-cache-dir pip virtualenv # No sudo; will upgrade packages in ~/.local unless running as root, e.g. in Docker
ENV_INIT := python $(PIP) --no-cache-dir pip wheel setuptools

ARCH := --platform linux/amd64,linux/arm64
AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --query "Account" --output text)
AWS_REGION ?= $(shell aws configure get region)
IMAGE ?= ecr-repo-mirror
REPO := $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com
TAG := latest

BUILD_COM := --progress plain --file docker/Dockerfile --build-arg aws_account=$(AWS_ACCOUNT)
MOUNT := 'type=bind,src=$(HOME)/.aws,dst=/root/.aws'
RUN := docker run --rm -it --mount $(MOUNT) $(IMAGE):$(TAG)

docker-builder:
	docker buildx ls | grep -q ecr-mirror-builder || docker buildx create --name ecr-mirror-builder --bootstrap --use $(ARCH)

docker-build-local:
	docker build $(BUILD_COM) -t $(IMAGE):$(TAG) .

docker-build-remote: ecr-login docker-build-remote-cred

docker-build-remote-cred: docker-builder
	docker buildx build $(ARCH) $(BUILD_COM) --tag $(REPO)/$(IMAGE):$(TAG) --push .

docker-clean:
	docker container rm `docker container ls -a -q`

docker-run: docker-build-local
	$(RUN)

docker-shell: docker-build-local
	$(RUN) /bin/bash

ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(REPO)

ecr-mirror:
	$(PY) ecr-mirror --registry-id $(AWS_ACCOUNT) sync

$(VENV):
	@echo Application Python version is $(PY_VER)
	@echo System Python binary is $(SYS_PY_BIN)
	@echo System Python version is $(SYS_PY_VER)
	@echo Pyenv binary, if needed, is $(PYENV_BIN)
	@echo Auto-detected Python binary is $(BASE_PY_BIN)
	@echo $(BASE_PY) | grep -q '*' && echo ERROR: $(BASE_PY) not found, install Python $(PY_VER) with Pyenv or override, as in BASE_PY=my/special/python make env-install && exit 1 || echo Using base Python at $(BASE_PY)
	$(BASE_PY) $(PY_INIT)
	$(BASE_PY) -m venv $(VENV)

env-install: $(VENV)
	$(ACTIVATE) && \
	$(ENV_INIT) && \
	python $(PIP) -r $(REQ).lock.txt

env-update: $(VENV)
	$(ACTIVATE) && \
	$(ENV_INIT) && \
	python $(PIP) --no-cache-dir -r $(REQ).txt && \
	python -m pip freeze --all > $(REQ).lock.txt
