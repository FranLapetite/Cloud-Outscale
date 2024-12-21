# Configure the Outscale provider
provider "outscale" {
  access_key_id = var.outscale_access_key
  secret_key_id = var.outscale_secret_key
  region        = var.outscale_region
}

terraform {
  required_providers {
    outscale = {
      source  = "outscale/outscale"
      version = "0.11.0" # Replace with the desired version
    }
  }
}

# Create a VPC (Net)
resource "outscale_net" "main_vpc" {
  ip_range = "10.0.0.0/16"

  tags {
    key   = "Name"
    value = "Main-VPC"
  }
}

# Public Subnet
resource "outscale_subnet" "public_subnet" {
  net_id   = outscale_net.main_vpc.net_id
  ip_range = "10.0.1.0/24"

  tags {
    key   = "Name"
    value = "Public-Subnet"
  }
}

# Private Subnet
resource "outscale_subnet" "private_subnet" {
  net_id   = outscale_net.main_vpc.net_id
  ip_range = "10.0.2.0/24"

  tags {
    key   = "Name"
    value = "Private-Subnet"
  }
}

# Create an Internet Service
resource "outscale_internet_service" "main_igw" {
  tags {
    key   = "Name"
    value = "Main-Internet-Service"
  }
}

# Attach the Internet Service to the Net
resource "outscale_internet_service_link" "main_igw_attachment" {
  internet_service_id = outscale_internet_service.main_igw.internet_service_id
  net_id              = outscale_net.main_vpc.net_id
}

# Create a Route Table
resource "outscale_route_table" "main_rt" {
  net_id = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "Main-Route-Table"
  }
}

# Associate Route Table with Public Subnet
resource "outscale_route_table_link" "public_subnet_association" {
  route_table_id = outscale_route_table.main_rt.route_table_id
  subnet_id      = outscale_subnet.public_subnet.subnet_id
}

# Create a route to the Internet Service
resource "outscale_route" "default_to_internet" {
  route_table_id       = outscale_route_table.main_rt.route_table_id
  destination_ip_range = "0.0.0.0/0"
  gateway_id           = outscale_internet_service.main_igw.internet_service_id
}

# Security Group allowing HTTP and HTTPS traffic
resource "outscale_security_group" "web_sg" {
  description = "Allow HTTP and HTTPS traffic"
  net_id      = outscale_net.main_vpc.net_id

  tags {
    key   = "Name"
    value = "Web-SG"
  }
}

# Ingress rules for HTTP
resource "outscale_security_group_rule" "http_ingress" {
  security_group_id = outscale_security_group.web_sg.security_group_id
  flow              = "Inbound"
  ip_protocol       = "tcp"
  from_port_range   = 80
  to_port_range     = 80
  ip_range          = "0.0.0.0/0"
}

# Ingress rules for HTTPS
resource "outscale_security_group_rule" "https_ingress" {
  security_group_id = outscale_security_group.web_sg.security_group_id
  flow              = "Inbound"
  ip_protocol       = "tcp"
  from_port_range   = 443
  to_port_range     = 443
  ip_range          = "0.0.0.0/0"
}

# Create a VM with a public IP
resource "outscale_vm" "web_server" {
  image_id         = var.image_id
  vm_type          = var.vm_type
  keypair_name     = var.keypair_name
  subnet_id        = outscale_subnet.public_subnet.subnet_id
  security_group_ids = [outscale_security_group.web_sg.security_group_id]

  tags {
    key   = "Name"
    value = "Web-Server"
  }
}