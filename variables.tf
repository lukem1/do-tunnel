# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
  sensitive   = true
  description = "DigitalOcean API token"
}

variable "ssh_key_fingerprint" {
  type        = string
  description = "SSH key fingerprint of the SSH key to add to the Droplet. Key must be added in DigitalOcean under Settings > Security > SSH Keys"
}
variable "ssh_private_key_file" {
  type        = string
  description = "Path to the SSH private key file to use to connect to the Droplet"
}
variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key file to add to the Droplet"
}

variable "domain" {
  type        = string
  description = "Domain or subdomain to attach to the Droplet. The domain must be configured in DigitalOcean under Networking > Domains"
}

# WireGuard

variable "wg_private_key" {
  type        = string
  sensitive   = true
  description = "The private key to use for the WireGuard server. Generated with the `wg genkey` command."
}

variable "wg_ipv4_range" {
  default     = "10.0.42.0/24"
  description = "WireGuard IPv4 Range"
}

variable "wg_port" {
  default     = "33099"
  description = "WireGuard Port"
}

variable "wg_allowed_peers" {
  type        = map(string)
  description = "WireGuard Peers allowed to connect to the server. Map of peer public key to WireGuard IP address."
}
