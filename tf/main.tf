terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "sg_1" {
  name = "default"

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHaM/DhbzbM0sG5DBP5ldfPFzguYJdtg/tl9/Uw3FKXLYPHauoiYqCztKtyuek1nGExSAeLPqUdOPafBjFgDk+Ziz8fmj4/rUkSmNeIdddsZGpxYhb8F273ftCrIhlvk+KX+AsvffJUiGvZ/dALC8EG1E2YXUSlB2alM1VHiCbNHV5AUWVteIWho99chO6WAljFH7R6kq23t/eP5hPOmd0Gtgw0H8PCMab58GbItviJGcigTct0lBTx1DSCEGpUobvEjnSBJ8ZnDsZT9CPRHcWe8u8RrOUzeI7hP+YA7kR28vIH6btsy1MtPufFimTNTnGoPc2Emy1NWPpkA7B1+CR kimang@KIMs-MacBook-Pro.local"
}

resource "aws_instance" "server_1" {
  ami             = "ami-ff0fea8310f3"
  instance_type   = "t3.micro"
  count           = 3
  key_name        = aws_key_pair.ec2_key.key_name
  security_groups = [aws_security_group.sg_1.name]
  # user_data                   = <<-EOF
  #             #!/bin/bash
  #             apt update -y
  #             apt install git -y
  #             apt install curl -y
  #             apt install ping -y

  #             # Install NVM
  #             curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  #             . ~/.nvm/nvm.sh

  #             # Install Node.js 18
  #             nvm install 18

  #             # Install PM2
  #             npm install pm2 -g

  #             # Clone Node.js repository
  #             git clone https://github.com/KimangKhenng/devops-ex /root/devops-ex

  #             # Navigate to the repository and start the app with PM2
  #             cd /root/devops-ex
  #             npm install
  #             pm2 start app.js --name node-app -- -p 8000
  #           EOF
  user_data_replace_on_change = true
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install python3 -y
            EOF
}