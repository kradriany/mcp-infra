# security_groups.tf

resource "aws_security_group" "mcp_sg" {
  name        = "mcp-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["${data.external.my_ip.result.ip}/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mcp-sg"
  }
}

# Fetch your public IP
data "external" "my_ip" {
  program = ["bash", "-c", "curl -s https://checkip.amazonaws.com | jq -R '{ip: .}'"]
}
