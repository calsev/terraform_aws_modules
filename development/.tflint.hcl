plugin "aws" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.23.0"
}
plugin "terraform" {
  enabled = true
  preset  = "all"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  version = "0.3.0"
}
rule "terraform_documented_outputs" {
  enabled = false
}
rule "terraform_documented_variables" {
  enabled = false
}
rule "terraform_standard_module_structure" {
  enabled = false
}
