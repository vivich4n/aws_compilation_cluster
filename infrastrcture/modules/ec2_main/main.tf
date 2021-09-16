resource "aws_security_group" "this" {
    name = "${var.env}-main"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 3632
        to_port     = 3632
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "that" {
    name = "${var.env}-ssh"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks  = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "main" {
  ami           = var.ami
  instance_type = var.ins_type
  subnet_id = var.public_subnet
  vpc_security_group_ids = [aws_security_group.that.id, aws_security_group.this.id]
  key_name = aws_key_pair.main_key_pair.key_name

  tags = {
    Name = "main_ec2"
  }
}
  
resource "aws_key_pair" "main_key_pair" {
    key_name       = "main_key_pair"
    public_key = file(var.ssh_key)
}