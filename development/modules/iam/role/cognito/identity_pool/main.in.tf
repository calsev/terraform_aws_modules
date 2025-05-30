data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [local.identity_pool_id]
    }
    dynamic "condition" {
      for_each = var.is_authenticated ? { this = {} } : {}
      content {
        test     = "ForAnyValue:StringLike"
        variable = "cognito-identity.amazonaws.com:amr"
        values   = ["authenticated"]
      }
    }
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
  }
}

module "this_role" {
  source                  = "../../../../iam/role/base"
  assume_role_json        = data.aws_iam_policy_document.assume_role_policy.json
  create_instance_profile = false
  embedded_role_policy_attach_arn_map = {
    # TODO: Tagging?
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
