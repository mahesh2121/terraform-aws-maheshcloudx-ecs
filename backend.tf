terraform {
  cloud {
    organization = "maheshcloudx"

    workspaces {
      name = "awsautoscaling"
    }
  }
}
