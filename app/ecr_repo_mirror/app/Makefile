SHELL := /bin/bash

# Below is the interface for the Python environment
PY_VER ?= 3.14
WD := .
UP := $(shell v=$$(printf '%s\n' "$(WD)" | sed 's#^\.$$##; s#[^/][^/]*#..#g'); echo "$${v:-.}")
REQ ?= requirements/requirements
VENV_SUB ?= ecr_mirror

VER_REGEX := sed -nE 's/.*([0-9]+\.[0-9]+)\.[0-9]+.*/\1/p'
MAJOR_MINOR_REGEX := sed -nE 's/^([0-9]+\.[0-9]+)(\.[0-9]+)?$$/\1/p'
SYS_PY_BIN := $(shell command -v python 2>/dev/null)
SYS_PY_VER := $(shell [ -n "$(SYS_PY_BIN)" ] && "$(SYS_PY_BIN)" --version 2>&1 | $(VER_REGEX))

# Resolve pyenv root in this order:
# 1. Explicit PYENV_ROOT from env or make var
# 2. pyenv root, if pyenv is on PATH
# 3. Common global locations
# 4. Common user-local locations
PYENV_ROOT ?= $(strip $(shell \
	if [ -n "$$PYENV_ROOT" ] && [ -d "$$PYENV_ROOT" ]; then \
		printf '%s\n' "$$PYENV_ROOT"; \
	elif command -v pyenv >/dev/null 2>&1; then \
		pyenv root 2>/dev/null; \
	else \
		for d in \
			/usr/local/pyenv \
			/opt/pyenv \
			/usr/local/opt/pyenv \
			/opt/homebrew/opt/pyenv \
			"$$HOME/.pyenv" \
			"$$HOME/.local/pyenv" \
		; do \
			if [ -d "$$d" ]; then \
				printf '%s\n' "$$d"; \
				break; \
			fi; \
		done; \
	fi))
PYENV_EXE := $(strip $(shell \
	if command -v pyenv >/dev/null 2>&1; then \
		command -v pyenv; \
	elif [ -n "$(PYENV_ROOT)" ] && [ -x "$(PYENV_ROOT)/bin/pyenv" ]; then \
		printf '%s\n' "$(PYENV_ROOT)/bin/pyenv"; \
	elif [ -x /usr/local/bin/pyenv ]; then \
		printf '%s\n' /usr/local/bin/pyenv; \
	elif [ -x /opt/homebrew/bin/pyenv ]; then \
		printf '%s\n' /opt/homebrew/bin/pyenv; \
	fi))

VENV := $(UP)/.venv/$(VENV_SUB)
ACTIVATE := source "$(VENV)/bin/activate"
PIP := -m pip install --upgrade
PY := $(ACTIVATE) &&
# Pin below as things break - especially setuptools
ENV_INIT := python $(PIP) --no-cache-dir pip wheel setuptools

AWS_ACCOUNT ?= $(shell aws sts get-caller-identity --query "Account" --output text)
AWS_REGION ?= $(shell aws configure get region)
REPO := $(AWS_ACCOUNT).dkr.ecr.$(AWS_REGION).amazonaws.com

# Below is the interface for Docker build
DOCKER_DIR ?= docker
DOCKERFILE ?= docker/Dockerfile
DOCKER_TARGET ?= remote
ARCH ?= linux/amd64,linux/arm64
IMAGE ?= ecr-repo-mirror
TAG ?= latest

DC_ENV := $(UP)/$(DOCKER_DIR)/env
DOCKERFILE := $(UP)/$(DOCKERFILE)
DC := docker compose -f $(UP)/$(DOCKER_DIR)/docker_compose.yml
ARCH_NAME := $(shell echo $(ARCH) | sed -nE 's/[,]/_/g; s/[/]/-/gp')

docker-builder:
	docker buildx ls | grep -q ^$(ARCH_NAME)[[:space:]] || docker buildx create --name $(ARCH_NAME) --bootstrap --platform $(ARCH)

docker-build-local: docker-env ecr-login
	$(DC) build

docker-build-manifest: ecr-login
	docker buildx imagetools create -t $(REPO)/$(IMAGE):$(TAG) \
		$(shell [[ "$$ARCH" == *'/amd64'* ]] && echo $(REPO)/$(IMAGE):$(TAG)-amd || echo '') \
		$(shell [[ "$$ARCH" == *'/arm64'* ]] && echo $(REPO)/$(IMAGE):$(TAG)-arm || echo '')

docker-build-remote: ecr-login docker-build-remote-cred

docker-build-remote-cred: docker-builder
	docker buildx build \
	--platform $(ARCH) \
	--builder $(ARCH_NAME) \
	--progress plain \
	--file $(DOCKERFILE) \
	--target $(DOCKER_TARGET) \
	--cache-from $(REPO)/$(IMAGE):$(TAG) \
	--tag $(REPO)/$(IMAGE):$(TAG) \
	--push $(UP)

docker-clean:
	docker container ls -aq | xargs docker stop | xargs docker rm 2> /dev/null || true

docker-down: docker-env
	$(DC) down -v

docker-env:
	[[ -f "$(DC_ENV)/.env" ]] || sed 's/\r$$//' "$(DC_ENV)/template.env" > "$(DC_ENV)/.env"
	@if ! grep -E "UID=" $(DC_ENV)/.env > /dev/null 2>&1; then \
		echo "GID=$(shell id -g)" >> $(DC_ENV)/.env; \
		echo "UID=$(shell id -u)" >> $(DC_ENV)/.env; \
		echo "USERNAME=$(shell [ "$(id -u)" = "1000" ] && echo $(id -un) || echo ubuntu)" >> $(DC_ENV)/.env; \
	fi

docker-nuke: docker-clean
	docker image ls -a | xargs docker image rm 2> /dev/null || true
	docker system prune -a

docker-up: docker-build-local
	$(DC) up --detach

ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(REPO)

$(VENV): python-ensure
	@$(call _python_resolve_sh); \
	if [ -z "$$BASE_PY_RESOLVED" ] || [ ! -x "$$BASE_PY_RESOLVED" ]; then \
		if [ -n "$$PYENV_EXE" ]; then \
			PYENV_PREFIX="$$(PYENV_ROOT="$$PYENV_ROOT" "$$PYENV_EXE" prefix "$(PY_VER)" 2>/dev/null)"; \
			PYENV_BIN="$$PYENV_PREFIX/bin/python"; \
			if [ -n "$$PYENV_BIN" ] && [ -x "$$PYENV_BIN" ]; then \
				BASE_PY_RESOLVED="$$PYENV_BIN"; \
				BASE_PY_SOURCE="pyenv"; \
			fi; \
		fi; \
	fi; \
	$(call _python_print_debug_sh); \
	if [ -z "$$BASE_PY_RESOLVED" ] || [ ! -x "$$BASE_PY_RESOLVED" ]; then \
		echo "ERROR: resolved base python not found or not executable"; \
		echo "Install Python $(PY_VER) with pyenv, or override BASE_PY=/my/special/python"; \
		exit 1; \
	fi; \
	echo "Creating venv with $$BASE_PY_SOURCE Python at $$BASE_PY_RESOLVED"; \
	"$$BASE_PY_RESOLVED" -m venv "$(VENV)"

env-clean:
	rm -rf "$(VENV)"

env-init: $(VENV)
	$(PY) $(ENV_INIT)
ifdef POETRY_DIR
	$(PY) python $(PIP) poetry
endif

env-install: env-init
ifdef REQ
	$(PY) python $(PIP) -r "$(UP)/$(REQ).lock.txt"
else ifdef POETRY_DIR
	$(PY) poetry -C "$(UP)/$(POETRY_DIR)" install --no-interaction --without dev,test
else
	@echo "ERROR: Either REQ or POETRY_DIR must be set"
	@exit 1
endif

env-test: env-init
ifdef REQ
	$(PY) python $(PIP) -r "$(UP)/$(REQ).lock.txt"
else ifdef POETRY_DIR
	$(PY) poetry -C "$(UP)/$(POETRY_DIR)" install --no-interaction --without dev --with test
else
	@echo "ERROR: Either REQ or POETRY_DIR must be set"
	@exit 1
endif

env-update: env-init
ifdef REQ
	$(PY) python $(PIP) --no-cache-dir -r "$(UP)/$(REQ).txt"
	$(PY) python -m pip freeze --all > "$(UP)/$(REQ).lock.txt"
else ifdef POETRY_DIR
	$(PY) poetry -C "$(UP)/$(POETRY_DIR)" lock --regenerate
	$(PY) poetry -C "$(UP)/$(POETRY_DIR)" install --no-interaction --without dev,test
else
	@echo "ERROR: Either REQ or POETRY_DIR must be set"
	@exit 1
endif

define _python_resolve_sh
SYS_PY_BIN="$(SYS_PY_BIN)"; \
SYS_PY_VER="$(SYS_PY_VER)"; \
PYENV_ROOT="$(PYENV_ROOT)"; \
PYENV_EXE="$(PYENV_EXE)"; \
PY_VER="$(PY_VER)"; \
BASE_PY_OVERRIDE="$(BASE_PY)"; \
REQ_PY_MAJOR_MINOR="$$(printf '%s\n' "$$PY_VER" | $(MAJOR_MINOR_REGEX))"; \
PYENV_PREFIX=""; \
PYENV_BIN=""; \
BASE_PY_RESOLVED=""; \
BASE_PY_SOURCE=""; \
if [ -n "$$PYENV_EXE" ]; then \
	PYENV_PREFIX="$$(PYENV_ROOT="$$PYENV_ROOT" "$$PYENV_EXE" prefix "$$PY_VER" 2>/dev/null)"; \
	if [ -n "$$PYENV_PREFIX" ]; then \
		PYENV_BIN="$$PYENV_PREFIX/bin/python"; \
	fi; \
fi; \
if [ -n "$$BASE_PY_OVERRIDE" ]; then \
	BASE_PY_RESOLVED="$$BASE_PY_OVERRIDE"; \
	BASE_PY_SOURCE="override"; \
elif [ -n "$$SYS_PY_BIN" ] && [ -n "$$REQ_PY_MAJOR_MINOR" ] && [ "$$REQ_PY_MAJOR_MINOR" = "$$SYS_PY_VER" ]; then \
	BASE_PY_RESOLVED="$$SYS_PY_BIN"; \
	BASE_PY_SOURCE="system"; \
elif [ -n "$$PYENV_BIN" ] && [ -x "$$PYENV_BIN" ]; then \
	BASE_PY_RESOLVED="$$PYENV_BIN"; \
	BASE_PY_SOURCE="pyenv"; \
fi
endef

define _python_print_debug_sh
echo "PY_VER='$$PY_VER'"; \
echo "REQ_PY_MAJOR_MINOR='$$REQ_PY_MAJOR_MINOR'"; \
echo "SYS_PY_BIN='$$SYS_PY_BIN'"; \
echo "SYS_PY_VER='$$SYS_PY_VER'"; \
echo "PYENV_ROOT='$$PYENV_ROOT'"; \
echo "PYENV_EXE='$$PYENV_EXE'"; \
echo "PYENV_PREFIX='$$PYENV_PREFIX'"; \
echo "PYENV_BIN='$$PYENV_BIN'"; \
echo "BASE_PY='$$BASE_PY_RESOLVED'"; \
echo "BASE_PY_SOURCE='$$BASE_PY_SOURCE'"
endef

python-debug:
	@$(call _python_resolve_sh); \
	$(call _python_print_debug_sh)

python-ensure:
	@$(call _python_resolve_sh); \
	$(call _python_print_debug_sh); \
	if [ -z "$(PY_VER)" ]; then \
		echo "ERROR: PY_VER is not set"; \
		exit 1; \
	fi; \
	if [ -n "$$BASE_PY_RESOLVED" ] && [ -x "$$BASE_PY_RESOLVED" ]; then \
		echo "Using $$BASE_PY_SOURCE Python at $$BASE_PY_RESOLVED"; \
	elif [ -n "$$PYENV_EXE" ]; then \
		echo "Python $(PY_VER) is not installed in pyenv; installing now"; \
		PYENV_ROOT="$$PYENV_ROOT" "$$PYENV_EXE" install -s "$(PY_VER)" || exit $$?; \
		PYENV_PREFIX="$$(PYENV_ROOT="$$PYENV_ROOT" "$$PYENV_EXE" prefix "$(PY_VER)" 2>/dev/null)"; \
		PYENV_BIN="$$PYENV_PREFIX/bin/python"; \
		if [ -n "$$PYENV_BIN" ] && [ -x "$$PYENV_BIN" ]; then \
			echo "Using pyenv Python at $$PYENV_BIN"; \
		else \
			echo "ERROR: pyenv install appeared to succeed, but python binary was not found"; \
			exit 1; \
		fi; \
	else \
		echo "ERROR: no matching system python found and pyenv is unavailable"; \
		echo "To fix:"; \
		echo "  - install pyenv, or"; \
		echo "  - set PYENV_ROOT correctly, or"; \
		echo "  - override BASE_PY, e.g. BASE_PY=/path/to/python make env-install"; \
		exit 1; \
	fi
