# networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.proxy_vpc.id
}

output "public_sg_out" {
  value = aws_security_group.proxy_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.proxy_public_subnet.*.id
}
