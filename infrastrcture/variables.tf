variable "region" {
    description = "The AWS region"
    default     = "us-east-1"
}

variable "ami" {
    description = "Name of the main ami"
    default     = "ami-049e7ad2a5a07a75b"
}

variable "env" {
    default = "compilation"
}

variable "ins_type" {
    default = "t2.micro"
}

variable "ec2number" {
    default = 2
}

variable "ec2min" {
    default = 1
}

variable "ec2max" {
    default = 3
}
