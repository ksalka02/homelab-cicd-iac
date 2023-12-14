locals {
  ebs_path = "/dev/sdf"

}
resource "aws_instance" "teamcity" {
  ami                    = "ami-03a6eaae9938c858c"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.tc_sg.id]
  availability_zone      = "us-east-1a"
  key_name               = "api_test_key"
  user_data = templatefile("tc_userdata.sh",
    {
      ebs_path = local.ebs_path
  })
  tags = {
    Name = "TCtest"
  }
  root_block_device {
    volume_size = 16
  }
}

resource "aws_ebs_volume" "docker_tc" {
  availability_zone = "us-east-1a"
  type              = "gp3"
  size              = 16
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = local.ebs_path
  volume_id   = aws_ebs_volume.docker_tc.id
  instance_id = aws_instance.teamcity.id
}

resource "aws_security_group" "tc_sg" {
  name = "tcssh"
  # description = "api ports"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "custom"
    from_port   = 8111
    to_port     = 8111
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
