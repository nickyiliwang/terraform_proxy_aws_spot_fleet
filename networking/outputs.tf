# networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.proxy_vpc.id
}

output "public_sg_out" {
  value = aws_security_group.proxy_sg["public"].id
}
