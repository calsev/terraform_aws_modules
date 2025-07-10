locals {
  output_data = {
    detector     = module.detector.data
    notification = module.notification.data
  }
}
