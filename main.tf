module "s3_autoscaling_lb" {
  source  = "./modules/aws-s3-autoscaling-lb"

  web_ami = "ami-0dcbf34e757d2a931"
}
