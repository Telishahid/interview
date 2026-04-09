provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]  # Canonical
}

resource "aws_instance" "My_EC2_Instance" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t3.micro"
    key_name        = "Batch-31-Key"
    user_data       = <<-EOF
                        #!/bin/bash
                        sudo apt update -y
                        sudo apt install nginx -y
                        EOF

    tags = {
        Name = "My_EC2_Instance"
    }

}

resource "aws_s3_bucket" "My_S3_Bucket" {
    bucket     = "my-new-s3-bucket-09042026"
    tags = {
        Name = "My_S3_Bucket"
    }
}