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

py-lint:
	$(PY) black --check ..
	$(PY) isort --check ..
	$(PY) flake8 ..
	$(PY) pyright .

tf-fmt:
	cd .. && $(FMT)

tf-fmt-lint: tf-fmt git-lint

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init
	cd .. && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/api && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/authorizer && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/domain && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/integration && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/route && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../api_gateway/stage && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app/docker && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app/requirements && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecs_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/open_vpn_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/web_static && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena/database && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena/named_query && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch/compute && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch/job && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn/cache_policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn/distribution && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn/origin_request_policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn/public_key && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cdn/public_key_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cert && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/build_image && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/deploy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/deploy/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/deploy/config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/deploy/group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/pipe && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/pipe_stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/remote && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/remote/account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/remote/connection && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ci_cd/remote/host && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/client_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/user_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../common && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../config/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/config_ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/record && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/sd_public && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/zone && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb/table && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb/terraform_lock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/auto_scaling_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/elastic_ip && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/instance_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/key_pair && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/network_interface && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr/repo && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/ami_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/compute && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/compute_fargate && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/dashboard && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/service && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecs/task && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../efs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elasticache && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elasticache/cluster && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elasticache/parameter_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elasticache/subnet_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elb && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elb/listener && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elb/listener_certificate && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elb/load_balancer && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../elb/target_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/alert && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/pattern && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/pattern/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/pattern/s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/trigger && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/trigger/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/trigger/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../event/trigger/s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/batch && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/lambda && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/mobile_analytics && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/rds && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/assume_role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/assume_role_external && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/bedrock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/bedrock/model_job && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/cdn && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/cdn/distribution && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build/net && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build/project && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/code_build/report && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/codestar && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/codestar/connection && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/cw && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/cw/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecs/service && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/efs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/event && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/event/bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/kms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/lambda && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/lambda/function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/lambda/net && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/mobile_analytics && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/s3/bucket_access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/sqs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/sqs/queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/step_function/machine && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/managed && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/name_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/cw && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/cw/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/ecr/repo && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/sns/topic && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/api_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/code_build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/code_pipe && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ec2/instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs/instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs/task && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/policy_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/rds_monitor && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user/password_policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda/function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda/permission && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../local_config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../module_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../name_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint/email_channel && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../pinpoint/sms_channel && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../random && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../random/password && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../random/tls_key && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds/instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds/proxy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../rds/subnet_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../s3/access_point && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/data && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/init_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/init_value && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/random && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/configuration_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/domain_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/email_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/rule_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm/secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sms/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns/alert_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns/topic && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sqs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sqs/dead_letter_queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sqs/queue && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ssm && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ssm/parameter_plain && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ssm/parameter_secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/default && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/id_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/nat_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/nat_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/networking && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/peering && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/vpc && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../waf && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl

tflint-install:
	./script/install_tf_and_tflint.sh 2> /dev/null
