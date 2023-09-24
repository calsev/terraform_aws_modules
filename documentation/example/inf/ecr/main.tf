provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "repo" {
  source = "path/to/modules/ecr_repo"
  repo_map = {
    ubuntu = {
      # These tags are for ecr-mirror
      base_image = "ubuntu"
      image_tag_list = [
        "latest",
      ]
    }
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
