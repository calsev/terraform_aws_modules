SHELL := /bin/bash

DEV_ROOT = $(shell pwd)
REQ := requirements/requirements.ci
VER_REGEX := sed -nre 's/.*?([0-9]+\.[0-9]+)\.[0-9]+.*/\1/p'
PY_VER ?= $(shell echo 3.12.0 | $(VER_REGEX))
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

TF := terraform
FMT := $(TF) fmt --recursive
LINT := tflint
VALIDATE := $(TF) validate

# https://github.com/terraform-linters/tflint/releases
TFLINT_VER := $(shell cat ver_tflint)

ci-deps:
	$(PY) cd .. && python -m development.script.download_ci_dependencies

$(VENV):
	@echo Application Python version is $(PY_VER)
	@echo System Python binary is $(SYS_PY_BIN)
	@echo System Python version is $(SYS_PY_VER)
	@echo Pyenv binary, if needed, is $(PYENV_BIN)
	@echo Auto-detected Python binary is $(BASE_PY_BIN)
	@echo $(BASE_PY) | grep -q '*' && echo ERROR: $(BASE_PY) not found, install Python $(PY_VER) with Pyenv or override, as in BASE_PY=my/special/python make env-install && exit 1 || echo Using base Python at $(BASE_PY)
	$(BASE_PY) $(PY_INIT)
	$(BASE_PY) -m venv $(VENV)

env-clean:
	rm -rf $(VENV)

env-install: $(VENV)
	$(ACTIVATE) && \
	$(ENV_INIT) # Break here to get new tools in the next command
	$(ACTIVATE) && \
	python $(PIP) -r $(REQ).lock.txt

env-update: $(VENV)
	$(ACTIVATE) && \
	$(ENV_INIT) # Break here to get new tools in the next command
	$(ACTIVATE) && \
	python $(PIP) --no-cache-dir -r $(REQ).txt && \
	python -m pip freeze --all > $(REQ).lock.txt

git-lint:
	git diff --exit-code

lint: make-lint tf-fmt-lint py-lint tf-lint

make:
	$(PY) python ../script/makefile.py '{}' --env-file '' --module-root '..' --module-ignore-postfixes 'development' 'documentation' '.git' 'script' '.venv'

make-lint: make git-lint

worker-metric:
	$(PY) python script/worker_metric.py

py-lint:
	$(PY) black --check ..
	$(PY) isort --check ..
	$(PY) flake8 ..
	$(PY) pyright .

tf-fmt:
	cd .. && $(FMT)

tf-fmt-lint: tf-fmt git-lint

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init{% for app_dir, app_data in app_dirs.items() %}
	cd {{ app_data.path }} && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl --call-module-type=all{% if app_data.var_file %} --var-file {{ app_data.var_file }}.tfvars{% endif %}{% endfor %}{% for mod_dir in mod_dirs %}
	cd {{ mod_dir }} && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl{% endfor %}

tflint-install:
	./script/install_tf_and_tflint.sh 2> /dev/null
