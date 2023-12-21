resource "aws_security_group" "players_api5" {
  name        = "players_api5"
  description = "api ports"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # security_groups = [aws_security_group.lb_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "https"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "custom"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    # security_groups = [aws_security_group.lb_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "players_api3" {
  name        = "players_api3"
  description = "api ports"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # security_groups = [aws_security_group.lb_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "https"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "custom"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # security_groups = [aws_security_group.lb_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com"
# }

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "security group for my access"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "custom"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    # cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "custom"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
