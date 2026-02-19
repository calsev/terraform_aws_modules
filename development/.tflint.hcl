plugin "aws" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.45.0" #TODO: Sync with spec files or find better way
}
plugin "terraform" {
  enabled = true
  preset  = "all"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.14.1" #TODO: Sync with spec files or find better way
}
rule "terraform_documented_outputs" {
  enabled = false
}
rule "terraform_documented_variables" {
  enabled = false
}
