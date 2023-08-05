# do-tunnel

DigitalOcean WireGuard Tunnel with Terraform and Ansible

## Usage

### WireGuard Keys

See [WireGuard: Key Generation](https://www.wireguard.com/quickstart/#key-generation) for details on how to create keys for the WireGuard server and peers.

### Variables

Create a `.tfvars` file defining the value of the Terraform variables.

See [variables.tf](./variables.tf) for a complete list of variables.

Example `.tfvars` file:
```
do_token             = "dop_v1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
ssh_key_fingerprint  = "aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa:aa"
ssh_private_key_file = "/home/user/.ssh/id_rsa"
ssh_public_key_file  = "/home/user/.ssh/id_rsa.pub"

domain = "wg.example.com"

# WireGuard

wg_port       = "33099"
wg_ipv4_range = "10.0.42.0/24"

wg_private_key   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx="
wg_allowed_peers = {
  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=" = "10.0.42.2"
}
```

### Apply

```bash
terraform init
terraform apply -var-file my-vars.tfvars
```

### Destroy

```bash
terraform destroy -var-file my-vars.tfvars
```

### Peer Configuration

Peer configurations vary depending on the platform. See [DigitalOcean: How to Set Up WireGuard - Configuring a WireGuard Peer](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04#step-7-configuring-a-wireguard-peer) for Linux instructions.

This Terraform does not support adding additional nodes after initial setup. 

To add additional nodes either do so manually or update the `.tfvars` file and destroy then recreate the infrastructure.
