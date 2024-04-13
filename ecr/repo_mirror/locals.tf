locals {
  output_data = {
    compute_cluster_map = module.computation.data
    iam = {
      policy = {
        (var.task_name) = module.ecr_mirror_policy.data
      }
    }
    repo = module.ecr_repo.data
    task = module.ecr_mirror_task.data
  }
  mirror_container_definition_list = [
    {
      command_list = [
        "make ecr-mirror",
      ]
      image = "${module.ecr_repo.data[var.ecr_repo_name].repo_url}:latest"
      name  = "ecr-mirror"
    },
  ]
}
