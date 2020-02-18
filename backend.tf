terraform {
  backend "local" {
    path = "/var/lib/jenkins/terraform/workspace/terraform.tfstate"
  }

}
