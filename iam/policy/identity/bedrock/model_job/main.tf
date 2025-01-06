module "this_policy" {
  source      = "../../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    application-inference-profile = local.arn_list_application_inference_profile
    custom-model                  = local.arn_list_model_custom
    evaluation-job                = local.arn_list_job_evaluation
    foundation-model              = local.arn_list_model_foundation
    inference-profile             = local.arn_list_inference_profile
    model-customization-job       = local.arn_list_job_model_customization
    model-evaluation-job          = local.arn_list_job_model_evaluation
    model-invocation-job          = local.arn_list_job_model_invocation
    provisioned-model             = local.arn_list_model_provisioned
  }
  service_name = "bedrock"
  std_map      = var.std_map
}
