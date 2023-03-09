SHELL := /bin/bash

REQ := requirements/requirements.ci
VER_REGEX := sed -nre 's/.*?([0-9]+\.[0-9]+)\.[0-9]+.*/\1/p'
PY_VER ?= $(shell echo 3.11.0 | $(VER_REGEX))
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
LINT := tflint
VALIDATE := $(TF) validate

# https://github.com/terraform-linters/tflint/releases
TFLINT_VER := v0.45.0

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
	$(ENV_INIT) && \
	python $(PIP) -r $(REQ).lock.txt

env-update: $(VENV)
	$(ACTIVATE) && \
	$(ENV_INIT) && \
	python $(PIP) --no-cache-dir -r $(REQ).txt && \
	python -m pip freeze --all > $(REQ).lock.txt

make:
	$(PY) python ../script/makefile.py '{}' --env-file '' --module-root '..' --module-postfixes '..' --module-ignore-postfixes '.git'

py-lint:
	$(PY) black --check ..
	$(PY) isort --check ..
	$(PY) flake8 ..
	$(PY) pyright ..

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init{% for app_dir, app_data in app_dirs.items() %}
	cd {{ app_data.path }} && $(LINT) --config=../development/.tflint.hcl --module{% if app_data.var_file %} --var-file {{ app_data.var_file }}.tfvars{% endif %}{% endfor %}{% for mod_dir in mod_dirs %}
	cd {{ mod_dir }} && $(LINT) --config=../development/.tflint.hcl{% endfor %}

tflint-install:
	@(command tflint && [[ `tflint --version` =~ $(TFLINT_VER) ]] && echo tflint $(TFLINT_VER) already installed) || (echo Installing tflint && cd /tmp && curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash)
