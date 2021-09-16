resource "aws_security_group" "this" {
    name = "${var.env}-farm"
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
    name = "${var.env}-farm-ssh"
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

resource "aws_key_pair" "farm_key_pair" {
    key_name       = "farm_key_pair"
    public_key = file(var.ssh_key)
}

resource "aws_launch_configuration" "this" {
  name_prefix = "${var.env}-farm"
  image_id      = var.ami
  instance_type = var.ins_type
  security_groups = [aws_security_group.this.id, aws_security_group.that.id]
  key_name = aws_key_pair.farm_key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.env}-farm"
  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.private_subnets
  max_size                  = var.ec2max
  min_size                  = var.ec2min
  desired_capacity          = var.ec2number

  lifecycle {
    create_before_destroy = true
  }
  
  tag {
    key                 = "Name"
    value               = "comp-farm"
    propagate_at_launch = true
  }  
}