# root/outputs.tf

output "instances" {
  value = [for ip in module.compute.instances[*].public_ip : "${ip}:8888"]
}
