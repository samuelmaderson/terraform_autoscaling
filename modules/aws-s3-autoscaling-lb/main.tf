
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-new-20220612"
}

resource "aws_s3_bucket_acl" "prod_tf_course_acl" {
  bucket = aws_s3_bucket.prod_tf_course.id
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inboud and evenrything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist_range
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist_range
  }

  tags = {
    "Terraform" : "true"
  }

}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    "Terraform" : "true"
  } 
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prodweb" {
  name = "elb-prod-web"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_launch_template" "asg_launch_prod_web" {
  name_prefix   = "asg_launch_prod_web"
  image_id      = var.web_ami
  instance_type = var.web_type
  vpc_security_group_ids = [aws_security_group.prod_web.id]
}

resource "aws_autoscaling_group" "asg_prod_web" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = var.web_desired
  max_size           = var.web_max
  min_size           = var.web_min

  launch_template {
    id      = aws_launch_template.asg_launch_prod_web.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_prod_web" {
  autoscaling_group_name = aws_autoscaling_group.asg_prod_web.id
  elb                    = aws_elb.prodweb.id
}
