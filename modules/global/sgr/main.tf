


// SG to onlly allow SSH connections from VPC public subnets
resource "aws_security_group" "vpc_sgr" {
  name        = "${var.namespace}-lambda-sgr"
  description = "Allow Lambda  inbound traffic"
  vpc_id      = var.vpc.vpc_id
  lifecycle { create_before_destroy = true }

  ingress {
    description = "Traffic to lambda only from internal VPC clients"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
 
  }

  ingress {
    description = "DB Services VPC clients"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  ingress {
    description = "DB Services VPC clients"
    from_port   = 1
    to_port     = 60000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-lambda-sgr"
  }
}




