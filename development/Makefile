SHELL := /bin/bash

DEV_ROOT = $(shell pwd)
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
FMT := $(TF) fmt --recursive
LINT := tflint
VALIDATE := $(TF) validate

# https://github.com/terraform-linters/tflint/releases
TFLINT_VER := $(shell cat tflint_ver)

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

py-lint:
	$(PY) black --check ..
	$(PY) isort --check ..
	$(PY) flake8 ..
	$(PY) pyright ..

tf-fmt:
	cd .. && $(FMT)

tf-fmt-lint: tf-fmt git-lint

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init
	cd .. && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/authorizer && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/integration && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/route && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/stage && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_mirror && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_mirror/docker && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_mirror/requirements && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app_web_static && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch_compute && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch_job && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cert && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd_build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd_pipe && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd_remote_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito_user_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../common && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw_config_ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns_sd_public && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns_zone && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb_terraform_lock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2_instance_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr_repo && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr_repo_mirror && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_ami_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_compute && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_compute_fargate && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_dashboard && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_service && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs_task && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../efs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_alert && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_pattern_s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_trigger && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event_trigger_s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/batch && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/mobile_analytics && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/rds && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/assume_role_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/assume_role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/assume_role_external && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/cdn && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build_net && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build_project && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build_report && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/codestar_connection && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/efs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/event_bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/kms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/lambda_net && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/mobile_analytics && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/sqs_queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/step_function_starter && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/ecr_repo && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/sns_topic && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy_managed && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/api_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/code_build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs_task && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/policy_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/rds_monitor && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../local_config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../module_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../name_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint_email_channel && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint_sms_channel && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../policy_name_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds_subnet_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../s3_access_point && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../security_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../security_group_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../security_group_rule_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses_configuration_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses_domain_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses_email_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm_secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sms_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns_alert_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns_topic && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sqs_dead_letter_queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sqs_queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ssm_parameter_plain && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ssm_parameter_secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_id_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_nat_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_nat_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_networking && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_peering && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc_stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../waf && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl

tflint-install:
	./script/install_tf_and_tflint.sh
