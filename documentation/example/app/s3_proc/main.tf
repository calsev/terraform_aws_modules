provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "s3" {
  source = "path/to/modules/s3/bucket"
  bucket_map = {
    (local.bucket_key) = {
      notification_enable_event_bridge = true
    }
  }
  std_map = module.com_lib.std_map
}

module "batch" {
  source = "path/to/modules/batch/compute"
  compute_map = {
    (local.compute_name) = {}
  }
  compute_instance_type_default = "c6g.medium"
  iam_data                      = data.terraform_remote_state.iam.outputs.data
  monitor_data                  = data.terraform_remote_state.monitor.outputs.data
  std_map                       = module.com_lib.std_map
  vpc_data_map                  = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default               = "main"
  vpc_segment_key_default       = "internal"
}

module "job" {
  source             = "path/to/modules/batch/job"
  batch_cluster_data = module.batch.data
  iam_data           = data.terraform_remote_state.iam.outputs.data
  job_map = {
    (local.job_name) = {
      batch_cluster_key = local.compute_name
    }
  }
  job_command_list_default               = ["echo", "Ref::bucket_name", "/", "Ref::object_key"]
  job_entry_point_default                = null
  job_iam_role_arn_job_container_default = module.job_role.data.iam_role_arn
  job_parameter_map_default = {
    bucket_name = "unknown-bucket"
    object_key  = "unknown-object"
  }
  monitor_data = data.terraform_remote_state.monitor.outputs.data
  std_map      = module.com_lib.std_map
}

module "s3_trigger" {
  source = "path/to/modules/event/trigger/s3/bucket"
  event_map = {
    task = {
      definition_arn            = module.job.data[local.job_name].job_definition_arn
      s3_bucket_name            = module.s3.data[local.bucket_key].name_effective
      s3_object_key_prefix_list = ["trigger-path/"]
      s3_object_key_suffix_list = [".txt", ".TXT"]
      target_arn                = module.batch.data[local.compute_name].batch_job_queue_arn
      target_service            = "batch"
    }
  }
  iam_data = data.terraform_remote_state.iam.outputs.data
  std_map  = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
