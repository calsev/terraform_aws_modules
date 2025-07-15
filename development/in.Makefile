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

PIP := -m pip install --upgrade
# Pin below as things break - especially setuptools
PY_INIT := $(PIP) --no-cache-dir pip virtualenv # No sudo; will upgrade packages in ~/.local unless running as root, e.g. in Docker
ENV_INIT := python $(PIP) --no-cache-dir pip wheel setuptools

TF := terraform
ENV := env/.env
FMT := $(TF) fmt --recursive
LINT := tflint
VALIDATE := $(TF) validate
FULL := ([[ -f $(ENV) ]] && source $(ENV) || echo No env sourced) && source "${VENV}/bin/activate" &&

# https://github.com/terraform-linters/tflint/releases
TFLINT_VER := $(shell cat ver_tflint)

ci-deps:
	$(FULL) cd .. && python -m development.script.download_ci_dependencies

$(ENV):
	cp env/template.env $(ENV)

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
	$(FULL) $(ENV_INIT)
	$(FULL) python $(PIP) -r $(REQ).lock.txt

env-update: $(VENV)
	$(FULL) $(ENV_INIT)
	$(FULL) python $(PIP) --no-cache-dir -r $(REQ).txt
	$(PFULLY) python -m pip freeze --all > $(REQ).lock.txt

git-lint:
	git diff --exit-code

lint: make-lint tf-fmt-lint py-lint tf-lint

make: $(ENV)
	$(FULL) python ../script/makefile.py '{"aws_profile": "CALSEV", "github_profile": "CALSEV"}' '{}' --module-root '..' --module-ignore-postfixes '["development", "documentation", ".git", "script", ".venv"]'

make-lint: make git-lint

module-import:
	$(FULL) cd .. && python development/script/module_import.py

module-render:
	$(FULL) cd .. && python development/script/module_render.py
	make tf-fmt

worker-metric:
	$(FULL) python script/worker_metric.py

py-lint:
	$(FULL) black --check ..
	$(FULL) isort --check ..
	$(FULL) flake8 ..
	$(FULL) pyright .

tf-fmt:
	cd .. && $(FMT)

tf-fmt-lint: tf-fmt git-lint

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init{% for app_dir, app_data in app_dirs.items() %}
	cd {{ app_data.path }} && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl --call-module-type=all{% if app_data.var_file %} --var-file {{ app_data.var_file }}.tfvars{% endif %}{% endfor %}{% for mod_dir in mod_dirs %}
	cd {{ mod_dir }} && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl{% endfor %}

tflint-install:
	./script/install_tf_and_tflint.sh 2> /dev/null
