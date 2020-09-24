provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

module "webserver_module" {
  source = "../modules/webserver"
  ami = "ami-08f4717d06813bf00"
  cidr_block = "10.0.0.0/16"
  instance_type = "t2.micro"
  vpc_id = aws_vpc.main.id
  webserver_name = "web01"
}

output "instance_data" {
  value = module.webserver_module.instance
}