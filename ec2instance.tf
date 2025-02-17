locals {
  ebs_path = "/dev/sdf"

}
resource "aws_instance" "teamcity" {
  # ami                    = "ami-03a6eaae9938c858c"
  ami           = "ami-053a45fff0a704a47"
  instance_type = "t2.medium"
  subnet_id     = "subnet-08d16ddb97d32a0ec"
  # vpc_security_group_ids = [aws_security_group.tc_sg.id]
  vpc_security_group_ids = ["sg-0270d4f6e39441c46"]
  availability_zone      = "us-east-1b"
  key_name               = "api_test_key"
  user_data = templatefile("tc_userdata.sh",
    {
      ebs_path = local.ebs_path
  })
  tags = {
    Name = "TeamCity"
  }
  root_block_device {
    volume_size = 8
  }
}

resource "aws_ebs_volume" "Teamcity_ebs_volume" {
  availability_zone = "us-east-1b"
  type              = "gp3"
  size              = 16
  snapshot_id       = "snap-0431051b082adb1be"

  tags = {
    Name = "Volume from Teamcity Snapshot"
  }
}


resource "aws_volume_attachment" "aws_volume_attachment" {
  device_name = local.ebs_path
  volume_id   = aws_ebs_volume.Teamcity_ebs_volume.id
  instance_id = aws_instance.teamcity.id
}

# resource "aws_security_group" "tc_sg" {
#   name = "teamcity"
#   # description = "api ports"
#   # vpc_id      = aws_vpc.main.id

#   ingress {
#     description = "ssh"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "custom"
#     from_port   = 8111
#     to_port     = 8111
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
