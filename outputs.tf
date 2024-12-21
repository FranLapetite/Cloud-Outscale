output "vpc_id" {
  description = "The ID of the VPC"
  value       = outscale_net.main_vpc.net_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = outscale_subnet.public_subnet.subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = outscale_subnet.private_subnet.subnet_id
}

output "web_server_id" {
  description = "The ID of the web server VM"
  value       = outscale_vm.web_server.vm_id
}