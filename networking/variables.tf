# networking/variables.tf

variable "vpc_cidr" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "security_groups" {}

variable "public_sn_count" {
  type = number
}

variable "public_cidrs" {
  type = list(any)
}

variable "max_subnets" {
  type = number
}

