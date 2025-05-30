locals {
  output_data = {
    for tag, _ in local.ami_tag_to_parameter_path : tag => jsondecode(data.aws_ssm_parameter.ecs_optimized_ami[tag].value)
  }
  ami_tag_to_parameter_path = {
    cpu_amd = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended",
    cpu_arm = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended",
    gpu_amd = "/aws/service/ecs/optimized-ami/amazon-linux-2/gpu/recommended",
  }
}
