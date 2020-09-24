terraform {
  backend "s3" {
    bucket = "tf-state-rj"
    key = "foo/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  version = "~> 2.65"
  region = "eu-west-1"
}

resource "aws_instance" "webserver" {
  ami = "ami-04137ed1a354f54c4"
  instance_type = "t2.micro"
  tags = {
    Name = "web01"
  }
}