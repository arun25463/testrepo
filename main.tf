terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  version = "~>3.5.0"
}

resource "aws_iam_role" "passion_role"{
  name = "passionSession"
  path="/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
    ]
}
  EOF
  tags = {
    Name = "tag-Passion"
  }
}

resource "aws_iam_role_policy_attachment" "passion-role-attach" {
  role       = aws_iam_role.passion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "passion_profile" {
  name = "passion_profile"
  role = aws_iam_role.passion_role.name
}

resource "aws_key_pair" "deployer" {
  key_name   = "inproduct"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 aruninproduct@gmail.com"
}

resource "aws_instance" "passionModel" {
  ami           = "ami-0bcc094591f354be2"
  instance_type = "t2.medium"
  key_name= aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  # vpc_security_group_ids=""
  subnet_id="subnet-042b4ec7a5997309a"
  #iam_instance_profile= aws_iam_role.passion_role.name
  iam_instance_profile= aws_iam_instance_profile.passion_profile.name
  tags = {
    Name = "ArunK_automated"
    Project = "Passion"
  }


  provisioner "local-exec"{
    command = "echo ${aws_instance.passionModel.public_ip} > instance_information.txt"
  }

  # connection{
  #     type="ssh"
  #     user="ubuntu"
  #     private_key=file("anzkp.pem")
  #     host = self.public_ip
  # }

  # provisioner "remote-exec" {
  #     inline=[
  #         "sudo apt update -y && sudo apt install -y nginx",
  #         "sudo systemctl start nginx",
  #         "touch arun1.txt"
  #     ]
  
  # }
}


