# compute/outputs.tf

output "instances" {
  value     = aws_instance.tf_ec2_node[*]
  sensitive = true
}

output "tg_attach_port_out" {
  value     = aws_lb_target_group_attachment.tf_tg_attach[0].port
  sensitive = true
}
