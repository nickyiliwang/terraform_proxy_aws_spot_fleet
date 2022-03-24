# compute/outputs.tf

output "instances" {
  value     = aws_spot_instance_request.proxy_nodes[*]
}
