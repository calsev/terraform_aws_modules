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

git-lint:
	git diff --exit-code

lint: make-lint tf-fmt-lint py-lint tf-lint

make:
	$(PY) python ../script/makefile.py '{}' --env-file '' --module-root '..' --module-ignore-postfixes 'development' 'documentation' '.git' 'script' '.venv'

make-lint: make git-lint

module-import:
	$(PY) cd .. && python development/script/module_import.py

module-render:
	$(PY) cd .. && python development/script/module_render.py

worker-metric:
	$(PY) python script/worker_metric.py

py-lint:
	$(PY) black --check ..
	$(PY) isort --check ..
	$(PY) flake8 ..
	$(PY) pyright .

tf-fmt:
	cd ../account && $(FMT)
	cd ../account/alternate_contact && $(FMT)
	cd ../api_gateway && $(FMT)
	cd ../api_gateway/api && $(FMT)
	cd ../api_gateway/authorizer && $(FMT)
	cd ../api_gateway/aws_account && $(FMT)
	cd ../api_gateway/domain && $(FMT)
	cd ../api_gateway/integration && $(FMT)
	cd ../api_gateway/route && $(FMT)
	cd ../api_gateway/stack && $(FMT)
	cd ../api_gateway/stage && $(FMT)
	cd ../app && $(FMT)
	cd ../app/alert_aws_account && $(FMT)
	cd ../app/ecr_repo_mirror && $(FMT)
	cd ../app/ecr_repo_mirror/app && $(FMT)
	cd ../app/ecr_repo_mirror/app/docker && $(FMT)
	cd ../app/ecr_repo_mirror/app/requirements && $(FMT)
	cd ../app/ecs_app && $(FMT)
	cd ../app/open_vpn_instance && $(FMT)
	cd ../app/reserved_instance_purchaser && $(FMT)
	cd ../app/reserved_instance_purchaser/app && $(FMT)
	cd ../app/web_static && $(FMT)
	cd ../athena && $(FMT)
	cd ../athena/database && $(FMT)
	cd ../athena/named_query && $(FMT)
	cd ../athena/workgroup && $(FMT)
	cd ../backup && $(FMT)
	cd ../backup/plan && $(FMT)
	cd ../backup/selection && $(FMT)
	cd ../backup/vault && $(FMT)
	cd ../batch && $(FMT)
	cd ../batch/compute && $(FMT)
	cd ../batch/job && $(FMT)
	cd ../budget && $(FMT)
	cd ../budget/budget && $(FMT)
	cd ../cdn && $(FMT)
	cd ../cdn/cache_policy && $(FMT)
	cd ../cdn/distribution && $(FMT)
	cd ../cdn/origin_request_policy && $(FMT)
	cd ../cdn/public_key && $(FMT)
	cd ../cdn/public_key_group && $(FMT)
	cd ../cert && $(FMT)
	cd ../ci_cd && $(FMT)
	cd ../ci_cd/aws_account && $(FMT)
	cd ../ci_cd/build && $(FMT)
	cd ../ci_cd/build_image && $(FMT)
	cd ../ci_cd/deploy && $(FMT)
	cd ../ci_cd/deploy/app && $(FMT)
	cd ../ci_cd/deploy/config && $(FMT)
	cd ../ci_cd/deploy/group && $(FMT)
	cd ../ci_cd/pipe && $(FMT)
	cd ../ci_cd/pipe_stack && $(FMT)
	cd ../ci_cd/remote && $(FMT)
	cd ../ci_cd/remote/account && $(FMT)
	cd ../ci_cd/remote/connection && $(FMT)
	cd ../ci_cd/remote/host && $(FMT)
	cd ../cloudtrail && $(FMT)
	cd ../cloudtrail/trail && $(FMT)
	cd ../cognito && $(FMT)
	cd ../cognito/client_app && $(FMT)
	cd ../cognito/identity_pool && $(FMT)
	cd ../cognito/user_group && $(FMT)
	cd ../cognito/user_pool && $(FMT)
	cd ../common && $(FMT)
	cd ../config && $(FMT)
	cd ../config/aws_account && $(FMT)
	cd ../config/recorder && $(FMT)
	cd ../cw && $(FMT)
	cd ../cw/config_ecs && $(FMT)
	cd ../cw/log_group && $(FMT)
	cd ../cw/metric_alarm && $(FMT)
	cd ../cw/metric_filter && $(FMT)
	cd ../directory && $(FMT)
	cd ../directory/directory && $(FMT)
	cd ../dns && $(FMT)
	cd ../dns/aws_account && $(FMT)
	cd ../dns/record && $(FMT)
	cd ../dns/sd_public && $(FMT)
	cd ../dns/zone && $(FMT)
	cd ../dynamodb && $(FMT)
	cd ../dynamodb/table && $(FMT)
	cd ../dynamodb/terraform_lock && $(FMT)
	cd ../ec2 && $(FMT)
	cd ../ec2/auto_scaling_group && $(FMT)
	cd ../ec2/elastic_ip && $(FMT)
	cd ../ec2/flow_log && $(FMT)
	cd ../ec2/instance_template && $(FMT)
	cd ../ec2/key_pair && $(FMT)
	cd ../ec2/network_interface && $(FMT)
	cd ../ecr && $(FMT)
	cd ../ecr/aws_account && $(FMT)
	cd ../ecr/repo && $(FMT)
	cd ../ecs && $(FMT)
	cd ../ecs/ami_map && $(FMT)
	cd ../ecs/aws_account && $(FMT)
	cd ../ecs/compute && $(FMT)
	cd ../ecs/compute_fargate && $(FMT)
	cd ../ecs/dashboard && $(FMT)
	cd ../ecs/service && $(FMT)
	cd ../ecs/task && $(FMT)
	cd ../efs && $(FMT)
	cd ../elasticache && $(FMT)
	cd ../elasticache/cluster && $(FMT)
	cd ../elasticache/parameter_group && $(FMT)
	cd ../elasticache/subnet_group && $(FMT)
	cd ../elb && $(FMT)
	cd ../elb/listener && $(FMT)
	cd ../elb/listener_certificate && $(FMT)
	cd ../elb/load_balancer && $(FMT)
	cd ../elb/target_group && $(FMT)
	cd ../event && $(FMT)
	cd ../event/alert && $(FMT)
	cd ../event/aws_account && $(FMT)
	cd ../event/bus && $(FMT)
	cd ../event/pattern && $(FMT)
	cd ../event/pattern/s3 && $(FMT)
	cd ../event/pattern/s3/bucket && $(FMT)
	cd ../event/trigger && $(FMT)
	cd ../event/trigger/base && $(FMT)
	cd ../event/trigger/s3 && $(FMT)
	cd ../event/trigger/s3/bucket && $(FMT)
	cd ../guard_duty && $(FMT)
	cd ../guard_duty/detector && $(FMT)
	cd ../iam && $(FMT)
	cd ../iam/access_analyzer && $(FMT)
	cd ../iam/access_analyzer/analyzer && $(FMT)
	cd ../iam/app && $(FMT)
	cd ../iam/app/backup && $(FMT)
	cd ../iam/app/batch && $(FMT)
	cd ../iam/app/bedrock && $(FMT)
	cd ../iam/app/ec2 && $(FMT)
	cd ../iam/app/ecr && $(FMT)
	cd ../iam/app/ecs && $(FMT)
	cd ../iam/app/lambda && $(FMT)
	cd ../iam/app/mobile_analytics && $(FMT)
	cd ../iam/app/rds && $(FMT)
	cd ../iam/app/support && $(FMT)
	cd ../iam/organization && $(FMT)
	cd ../iam/organization/account && $(FMT)
	cd ../iam/organization/organization && $(FMT)
	cd ../iam/policy && $(FMT)
	cd ../iam/policy/assume_role && $(FMT)
	cd ../iam/policy/identity && $(FMT)
	cd ../iam/policy/identity/access_resource && $(FMT)
	cd ../iam/policy/identity/assume_role && $(FMT)
	cd ../iam/policy/identity/base && $(FMT)
	cd ../iam/policy/identity/bedrock && $(FMT)
	cd ../iam/policy/identity/bedrock/agent_alias && $(FMT)
	cd ../iam/policy/identity/bedrock/model_job && $(FMT)
	cd ../iam/policy/identity/cdn && $(FMT)
	cd ../iam/policy/identity/cdn/distribution && $(FMT)
	cd ../iam/policy/identity/code_build && $(FMT)
	cd ../iam/policy/identity/code_build/net && $(FMT)
	cd ../iam/policy/identity/code_build/project && $(FMT)
	cd ../iam/policy/identity/code_build/report && $(FMT)
	cd ../iam/policy/identity/codestar && $(FMT)
	cd ../iam/policy/identity/codestar/connection && $(FMT)
	cd ../iam/policy/identity/cw && $(FMT)
	cd ../iam/policy/identity/cw/log_group && $(FMT)
	cd ../iam/policy/identity/dynamodb && $(FMT)
	cd ../iam/policy/identity/dynamodb/table && $(FMT)
	cd ../iam/policy/identity/ecr && $(FMT)
	cd ../iam/policy/identity/ecs && $(FMT)
	cd ../iam/policy/identity/ecs/service && $(FMT)
	cd ../iam/policy/identity/efs && $(FMT)
	cd ../iam/policy/identity/event && $(FMT)
	cd ../iam/policy/identity/event/bus && $(FMT)
	cd ../iam/policy/identity/kms && $(FMT)
	cd ../iam/policy/identity/kms/key && $(FMT)
	cd ../iam/policy/identity/lambda && $(FMT)
	cd ../iam/policy/identity/lambda/function && $(FMT)
	cd ../iam/policy/identity/lambda/net && $(FMT)
	cd ../iam/policy/identity/mobile_analytics && $(FMT)
	cd ../iam/policy/identity/s3 && $(FMT)
	cd ../iam/policy/identity/s3/bucket && $(FMT)
	cd ../iam/policy/identity/s3/bucket_access_resource && $(FMT)
	cd ../iam/policy/identity/secret && $(FMT)
	cd ../iam/policy/identity/sns && $(FMT)
	cd ../iam/policy/identity/sqs && $(FMT)
	cd ../iam/policy/identity/sqs/queue && $(FMT)
	cd ../iam/policy/identity/step_function && $(FMT)
	cd ../iam/policy/identity/step_function/machine && $(FMT)
	cd ../iam/policy/managed && $(FMT)
	cd ../iam/policy/map && $(FMT)
	cd ../iam/policy/name_map && $(FMT)
	cd ../iam/policy/resource && $(FMT)
	cd ../iam/policy/resource/access_resource && $(FMT)
	cd ../iam/policy/resource/cw && $(FMT)
	cd ../iam/policy/resource/cw/log_group && $(FMT)
	cd ../iam/policy/resource/ecr && $(FMT)
	cd ../iam/policy/resource/ecr/repo && $(FMT)
	cd ../iam/policy/resource/event && $(FMT)
	cd ../iam/policy/resource/event/bus && $(FMT)
	cd ../iam/policy/resource/kms && $(FMT)
	cd ../iam/policy/resource/kms/key && $(FMT)
	cd ../iam/policy/resource/s3 && $(FMT)
	cd ../iam/policy/resource/s3/bucket && $(FMT)
	cd ../iam/policy/resource/sns && $(FMT)
	cd ../iam/policy/resource/sns/topic && $(FMT)
	cd ../iam/role && $(FMT)
	cd ../iam/role/api_gateway && $(FMT)
	cd ../iam/role/base && $(FMT)
	cd ../iam/role/code_build && $(FMT)
	cd ../iam/role/code_pipe && $(FMT)
	cd ../iam/role/cognito && $(FMT)
	cd ../iam/role/cognito/identity_pool && $(FMT)
	cd ../iam/role/ec2 && $(FMT)
	cd ../iam/role/ec2/instance && $(FMT)
	cd ../iam/role/ecs && $(FMT)
	cd ../iam/role/ecs/instance && $(FMT)
	cd ../iam/role/ecs/task && $(FMT)
	cd ../iam/role/ecs/task_execution && $(FMT)
	cd ../iam/role/policy_map && $(FMT)
	cd ../iam/role/rds_monitor && $(FMT)
	cd ../iam/role/service_linked && $(FMT)
	cd ../iam/role/step_function && $(FMT)
	cd ../iam/role/workspaces && $(FMT)
	cd ../iam/role/workspaces/default && $(FMT)
	cd ../iam/user && $(FMT)
	cd ../iam/user/password_policy && $(FMT)
	cd ../iam/user_group && $(FMT)
	cd ../inspect && $(FMT)
	cd ../inspect/enabler && $(FMT)
	cd ../kms && $(FMT)
	cd ../kms/key && $(FMT)
	cd ../lambda && $(FMT)
	cd ../lambda/alb_target && $(FMT)
	cd ../lambda/function && $(FMT)
	cd ../lambda/permission && $(FMT)
	cd ../local_config && $(FMT)
	cd ../macie && $(FMT)
	cd ../macie/aws_account && $(FMT)
	cd ../module_template && $(FMT)
	cd ../module_template/module_template && $(FMT)
	cd ../name_map && $(FMT)
	cd ../pinpoint && $(FMT)
	cd ../pinpoint/app && $(FMT)
	cd ../pinpoint/email_channel && $(FMT)
	cd ../pinpoint/sms_channel && $(FMT)
	cd ../random && $(FMT)
	cd ../random/password && $(FMT)
	cd ../random/tls_key && $(FMT)
	cd ../rds && $(FMT)
	cd ../rds/instance && $(FMT)
	cd ../rds/proxy && $(FMT)
	cd ../rds/subnet_group && $(FMT)
	cd ../s3 && $(FMT)
	cd ../s3/access_point && $(FMT)
	cd ../s3/bucket && $(FMT)
	cd ../s3/public_access_block && $(FMT)
	cd ../sagemaker && $(FMT)
	cd ../sagemaker/domain && $(FMT)
	cd ../secret && $(FMT)
	cd ../secret/data && $(FMT)
	cd ../secret/init_map && $(FMT)
	cd ../secret/init_value && $(FMT)
	cd ../secret/random && $(FMT)
	cd ../ses && $(FMT)
	cd ../ses/configuration_set && $(FMT)
	cd ../ses/domain_identity && $(FMT)
	cd ../ses/email_identity && $(FMT)
	cd ../ses/ip_pool && $(FMT)
	cd ../sg && $(FMT)
	cd ../sg/app && $(FMT)
	cd ../sg/group && $(FMT)
	cd ../sg/rule_set && $(FMT)
	cd ../sm && $(FMT)
	cd ../sm/rotation && $(FMT)
	cd ../sm/secret && $(FMT)
	cd ../sms && $(FMT)
	cd ../sms/aws_account && $(FMT)
	cd ../sns && $(FMT)
	cd ../sns/topic && $(FMT)
	cd ../sqs && $(FMT)
	cd ../sqs/dead_letter_queue && $(FMT)
	cd ../sqs/queue && $(FMT)
	cd ../ssm && $(FMT)
	cd ../ssm/parameter_plain && $(FMT)
	cd ../ssm/parameter_secret && $(FMT)
	cd ../step_function && $(FMT)
	cd ../vpc && $(FMT)
	cd ../vpc/default && $(FMT)
	cd ../vpc/endpoint && $(FMT)
	cd ../vpc/id_map && $(FMT)
	cd ../vpc/instance_connect_endpoint && $(FMT)
	cd ../vpc/nat_gateway && $(FMT)
	cd ../vpc/nat_instance && $(FMT)
	cd ../vpc/networking && $(FMT)
	cd ../vpc/peering && $(FMT)
	cd ../vpc/stack && $(FMT)
	cd ../vpc/vpc && $(FMT)
	cd ../waf && $(FMT)
	cd ../waf/acl && $(FMT)
	cd ../waf/logging_configuration && $(FMT)
	cd ../workspaces && $(FMT)
	cd ../workspaces/directory && $(FMT)
	cd ../workspaces/workspace && $(FMT)

tf-fmt-lint: tf-fmt git-lint

tf-lint: tflint-install
	$(LINT) --config=.tflint.hcl --init
	cd ../account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../account/alternate_contact && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../app/alert_aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app/docker && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecr_repo_mirror/app/requirements && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/ecs_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/open_vpn_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/reserved_instance_purchaser && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/reserved_instance_purchaser/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../app/web_static && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena/database && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena/named_query && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../athena/workgroup && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../backup && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../backup/plan && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../backup/selection && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../backup/vault && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch/compute && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../batch/job && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../budget && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../budget/budget && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../cloudtrail && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cloudtrail/trail && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/client_app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/identity_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/user_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cognito/user_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../common && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../config/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../config/recorder && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/config_ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/log_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/metric_alarm && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../cw/metric_filter && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../directory && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../directory/directory && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/record && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/sd_public && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dns/zone && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb/table && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../dynamodb/terraform_lock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/auto_scaling_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/elastic_ip && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/flow_log && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/instance_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/key_pair && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ec2/network_interface && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ecr/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../guard_duty && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../guard_duty/detector && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/access_analyzer && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/access_analyzer/analyzer && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/backup && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/batch && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/bedrock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/lambda && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/mobile_analytics && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/rds && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/app/support && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/organization && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/organization/account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/organization/organization && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/assume_role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/access_resource && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/assume_role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/bedrock && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/bedrock/agent_alias && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../iam/policy/identity/dynamodb && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/dynamodb/table && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecr && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/ecs/service && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/efs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/event && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/event/bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/kms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/identity/kms/key && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../iam/policy/resource/event && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/event/bus && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/kms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/kms/key && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/s3 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/s3/bucket && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/policy/resource/sns/topic && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/api_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/base && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/code_build && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/code_pipe && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/cognito && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/cognito/identity_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ec2 && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ec2/instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs/instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs/task && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/ecs/task_execution && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/policy_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/rds_monitor && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/service_linked && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/step_function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/workspaces && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/role/workspaces/default && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user/password_policy && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../iam/user_group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../inspect && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../inspect/enabler && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../kms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../kms/key && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda/alb_target && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda/function && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../lambda/permission && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../local_config && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../macie && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../macie/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../module_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../module_template/module_template && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../s3/public_access_block && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sagemaker && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sagemaker/domain && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/data && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/init_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/init_value && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../secret/random && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/configuration_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/domain_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/email_identity && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../ses/ip_pool && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/app && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/group && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sg/rule_set && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm/rotation && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sm/secret && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sms && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sms/aws_account && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../sns && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
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
	cd ../vpc/endpoint && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/id_map && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/instance_connect_endpoint && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/nat_gateway && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/nat_instance && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/networking && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/peering && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/stack && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../vpc/vpc && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../waf && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../waf/acl && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../waf/logging_configuration && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../workspaces && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../workspaces/directory && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl
	cd ../workspaces/workspace && $(LINT) --config=$(DEV_ROOT)/.tflint.hcl

tflint-install:
	./script/install_tf_and_tflint.sh 2> /dev/null
