#!/usr/bin/env bash
set -ex

sys='linux'
arch=$(dpkg-architecture -q DEB_BUILD_ARCH)
tf_ver=$(cat ver_tf)
tflint_ver=$(cat ver_tflint)
bucket=cdn-bucket.calsev.com

if [ -x "$(command -v terraform)" ] && [[ "$(terraform --version)" =~ $tf_ver ]]; then
  echo Terraform installed, skipping
else
  aws s3 cp --no-progress "s3://$bucket/installer/terraform_${sys}_${arch}_${tf_ver}" terraform
  chmod 755 terraform
  sudo chown root:root terraform
  sudo mv -f terraform /usr/local/bin/terraform
fi

if [ -x "$(command -v tflint)" ] && [[ "$(tflint --version)" =~ $tflint_ver ]]; then
  echo TFLint installed, skipping
else
  aws s3 cp --no-progress "s3://$bucket/installer/tflint_${sys}_${arch}_${tflint_ver}" tflint
  chmod 755 tflint
  sudo chown root:root tflint
  sudo mv -f tflint /usr/local/bin/tflint
fi

terraform --version
tflint --version

tflint_aws_ver=0.40.0 #TODO: Sync with .tflint.hcl or find better way
tflint_tf_ver=0.12.0 #TODO: Sync with .tflint.hcl or find better way
tflint_aws_bin="${HOME}/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-aws/${tflint_aws_ver}/tflint-ruleset-aws"
tflint_tf_bin="${HOME}/.tflint.d/plugins/github.com/terraform-linters/tflint-ruleset-terraform/${tflint_tf_ver}/tflint-ruleset-terraform"

if [ -f "$tflint_aws_bin" ]; then
  echo tflint-ruleset-aws installed, skipping
else
  aws s3 cp --no-progress \
    "s3://$bucket/installer/tflint_ruleset_aws_${sys}_${arch}_${tflint_aws_ver}" \
    "${tflint_aws_bin}"
  chmod 755 "${tflint_aws_bin}"
fi

if [ -f "$tflint_tf_bin" ]; then
  echo tflint-ruleset-terraform installed, skipping
else
  aws s3 cp --no-progress \
    "s3://$bucket/installer/tflint_ruleset_terraform_${sys}_${arch}_${tflint_tf_ver}" \
    "${tflint_tf_bin}"
  chmod 755 "${tflint_tf_bin}"
fi
