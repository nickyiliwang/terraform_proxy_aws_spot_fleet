# root/outputs.tf

output "instances" {
  value = module.compute.instances[*].public_ip
}
