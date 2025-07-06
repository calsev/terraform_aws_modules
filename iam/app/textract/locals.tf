locals {
  output_data = {
    textract_analyze = module.analyze_policy.data["textract_analyze"]
  }
}
