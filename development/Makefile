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
	$(PY) python ../script/makefile.py '{}' --env-file '' --module-root '..' --module-postfixes '..' --module-ignore-postfixes '.git'

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
	cd ../api_gateway && $(LINT) --config=../development/.tflint.hcl
	cd ../api_gateway_authorizer && $(LINT) --config=../development/.tflint.hcl
	cd ../api_gateway_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../api_gateway_integration && $(LINT) --config=../development/.tflint.hcl
	cd ../api_gateway_route && $(LINT) --config=../development/.tflint.hcl
	cd ../api_gateway_stage && $(LINT) --config=../development/.tflint.hcl
	cd ../app && $(LINT) --config=../development/.tflint.hcl
	cd ../app_web_static && $(LINT) --config=../development/.tflint.hcl
	cd ../batch_compute && $(LINT) --config=../development/.tflint.hcl
	cd ../batch_job && $(LINT) --config=../development/.tflint.hcl
	cd ../cdn && $(LINT) --config=../development/.tflint.hcl
	cd ../cert && $(LINT) --config=../development/.tflint.hcl
	cd ../ci_cd_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../ci_cd_build && $(LINT) --config=../development/.tflint.hcl
	cd ../ci_cd_pipe && $(LINT) --config=../development/.tflint.hcl
	cd ../ci_cd_remote_account && $(LINT) --config=../development/.tflint.hcl
	cd ../cognito_user_pool && $(LINT) --config=../development/.tflint.hcl
	cd ../common && $(LINT) --config=../development/.tflint.hcl
	cd ../cw_config_ecs && $(LINT) --config=../development/.tflint.hcl
	cd ../development && $(LINT) --config=../development/.tflint.hcl
	cd ../dns_sd_public && $(LINT) --config=../development/.tflint.hcl
	cd ../dns_zone && $(LINT) --config=../development/.tflint.hcl
	cd ../documentation && $(LINT) --config=../development/.tflint.hcl
	cd ../dynamodb && $(LINT) --config=../development/.tflint.hcl
	cd ../dynamodb_terraform_lock && $(LINT) --config=../development/.tflint.hcl
	cd ../ec2_instance_template && $(LINT) --config=../development/.tflint.hcl
	cd ../ecr_repo && $(LINT) --config=../development/.tflint.hcl
	cd ../ecr_repo_mirror && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_ami_map && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_compute && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_compute_fargate && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_dashboard && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_service && $(LINT) --config=../development/.tflint.hcl
	cd ../ecs_task && $(LINT) --config=../development/.tflint.hcl
	cd ../efs && $(LINT) --config=../development/.tflint.hcl
	cd ../event_alert && $(LINT) --config=../development/.tflint.hcl
	cd ../event_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../event_bus && $(LINT) --config=../development/.tflint.hcl
	cd ../event_pattern_s3 && $(LINT) --config=../development/.tflint.hcl
	cd ../event_trigger && $(LINT) --config=../development/.tflint.hcl
	cd ../event_trigger_s3 && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_app_batch && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_app_ecr && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_app_ecs && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_app_mobile_analytics && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_app_rds && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_assume_role_map && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_assume_role && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_assume_role_external && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_access_resource && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_cdn && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_code_build_net && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_code_build_project && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_code_build_report && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_codestar_connection && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_ecr && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_efs && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_event_bus && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_kms && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_lambda_net && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_log_group && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_mobile_analytics && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_s3 && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_secret && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_sns && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_sqs_queue && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_identity_step_function_starter && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_managed && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_map && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_resource_access_resource && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_resource_ecr_repo && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_resource_log_group && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_resource_s3 && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_policy_resource_sns_topic && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_api_gateway && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_code_build && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_ecs_instance && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_ecs_task && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_policy_map && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_rds_monitor && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_role_step_function && $(LINT) --config=../development/.tflint.hcl
	cd ../iam_user_group && $(LINT) --config=../development/.tflint.hcl
	cd ../lambda_function && $(LINT) --config=../development/.tflint.hcl
	cd ../local_config && $(LINT) --config=../development/.tflint.hcl
	cd ../log_group && $(LINT) --config=../development/.tflint.hcl
	cd ../module_template && $(LINT) --config=../development/.tflint.hcl
	cd ../name_map && $(LINT) --config=../development/.tflint.hcl
	cd ../pinpoint_app && $(LINT) --config=../development/.tflint.hcl
	cd ../pinpoint_email_channel && $(LINT) --config=../development/.tflint.hcl
	cd ../pinpoint_sms_channel && $(LINT) --config=../development/.tflint.hcl
	cd ../policy_name_map && $(LINT) --config=../development/.tflint.hcl
	cd ../rds_instance && $(LINT) --config=../development/.tflint.hcl
	cd ../rds_subnet_group && $(LINT) --config=../development/.tflint.hcl
	cd ../s3 && $(LINT) --config=../development/.tflint.hcl
	cd ../s3_access_point && $(LINT) --config=../development/.tflint.hcl
	cd ../script && $(LINT) --config=../development/.tflint.hcl
	cd ../secret && $(LINT) --config=../development/.tflint.hcl
	cd ../security_group && $(LINT) --config=../development/.tflint.hcl
	cd ../security_group_app && $(LINT) --config=../development/.tflint.hcl
	cd ../security_group_rule_set && $(LINT) --config=../development/.tflint.hcl
	cd ../ses_configuration_set && $(LINT) --config=../development/.tflint.hcl
	cd ../ses_domain_identity && $(LINT) --config=../development/.tflint.hcl
	cd ../ses_email_identity && $(LINT) --config=../development/.tflint.hcl
	cd ../sm_secret && $(LINT) --config=../development/.tflint.hcl
	cd ../sms_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../sns_alert_aws_account && $(LINT) --config=../development/.tflint.hcl
	cd ../sns_topic && $(LINT) --config=../development/.tflint.hcl
	cd ../sqs_dead_letter_queue && $(LINT) --config=../development/.tflint.hcl
	cd ../sqs_queue && $(LINT) --config=../development/.tflint.hcl
	cd ../ssm_parameter_plain && $(LINT) --config=../development/.tflint.hcl
	cd ../ssm_parameter_secret && $(LINT) --config=../development/.tflint.hcl
	cd ../step_function && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_id_map && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_nat_gateway && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_nat_instance && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_networking && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_peering && $(LINT) --config=../development/.tflint.hcl
	cd ../vpc_stack && $(LINT) --config=../development/.tflint.hcl
	cd ../waf && $(LINT) --config=../development/.tflint.hcl

tflint-install:
	./script/install_tf_and_tflint.sh
