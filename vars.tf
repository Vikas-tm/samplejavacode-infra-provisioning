variable "key_name" {
  default = "DevOps-301-AWS-us-west-1"
}

variable "pvt_key" {
  default = "/var/lib/jenkins/awspemkeys/DevOps-301-AWS-us-west-1.pem"
}

variable "sg-id" {
  default = "sg-0a3df514650639e12"
}

variable "amis" {
  default = "ami-0713f98de93617bb4"
}

variable "instancetypes" {
  default = "t2.micro"
}

variable "user_name" {
  default = "ec2-user"
}

