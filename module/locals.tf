locals {
  ingress_ports = {
    "22" = {
      cidrs       = ["212.159.65.209/32"]
      description = "Allow SSH access"
    }
  }
}
