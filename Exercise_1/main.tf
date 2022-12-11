provider "aws" {
  access_key = "open"
  secret_key = "sesame"
  region = "us-east-1"
}

resource "aws_instance" "Udacity1" {
    count = "4"
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "t2.micro"
    tags = {
        Name = "Udacity T2"
    }
}

resource "aws_instance" "Udacity2" {
    count = "0"
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "m4.large"
    tags = {
        Name = "Udacity M4"
    }
}

