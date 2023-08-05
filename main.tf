terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.29.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "tunnel" {
  image      = "ubuntu-22-10-x64"
  name       = "ubuntu-tunnel"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  ssh_keys   = [var.ssh_key_fingerprint]
  monitoring = true

  # Note that while remote-exec is not doing much here
  # it is important as without it local-exec would not wait
  # for the droplet to actually boot.
  # https://www.digitalocean.com/community/tutorials/how-to-use-ansible-with-terraform-for-configuration-management
  provisioner "remote-exec" {
    inline = ["echo \"Connected to droplet.\""]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_file)
    }
  }

  provisioner "local-exec" {
    command = join(" ", [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook -u root -i '${self.ipv4_address},'",
      "--private-key ${var.ssh_private_key_file} -e 'pub_key=${var.ssh_public_key_file}'",
      "--extra-vars \"${replace(jsonencode({
        wg_priv_key   = var.wg_private_key
        wg_ipv4_range = var.wg_ipv4_range
        wg_port       = var.wg_port
        wg_peers      = var.wg_allowed_peers
      }), "\"", "\\\"")}\"",
      "wireguard.yml"
      ]
    )
  }
}

resource "digitalocean_domain" "tunnel" {
  name       = var.domain
  ip_address = digitalocean_droplet.tunnel.ipv4_address
}

output "tunnel_ip" {
  value = digitalocean_droplet.tunnel.ipv4_address
}
