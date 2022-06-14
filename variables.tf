variable "web_ami" {
  type    = string
  default = "ami-0dcbf34e757d2a931"
}

variable "web_min" {
  type = number
  default = 2
}

variable "web_max" {
  type = number
  default = 2
}

variable "web_desired" {
  type = number
  default = 2
}

variable "web_type" {
  type    = string
  default = "t2.nano"
}

variable "whitelist_range" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}