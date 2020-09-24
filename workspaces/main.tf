terraform {
  backend "s3" {
    bucket = "tf-state-rj"
    key = "foo/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  version = "~> 2.65"
  region = var.region
}

locals {
  instance_name = "${terraform.workspace}.instance"
}

resource "aws_instance" "webserver" {
  ami = var.ami
  #ami = "ami-04137ed1a354f54c4"
  instance_type = var.instance_type
  tags = {
    Name = local.instance_name
  }
}