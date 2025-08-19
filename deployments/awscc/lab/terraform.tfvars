# IDs for existing network components
vpc_id              = "12345678"
core_priv_subnet_id = "87654321"
engines_priv_subnet_id = "963258741"
# Replace the following placeholder IDs with real subnet IDs
entry_pub_subnet_id   = "subnet-ENTRY"

lab_name = "lightrail-prod"
region   = "il-central-1"
domain   = "oxygen.example.com"
public_key_file  = "~/.ssh/oxy-dev.pub"
private_key_file = "~/.ssh/oxy-dev"

enable_vpc_dnsnames = true
anti_virus_sqs     = false
cidr_vpc_block     = "10.0.0.0/16"

entry_pub_subnet = {
  cidr_block         = "10.0.0.0/24"
  cidr_reserved_block = "10.0.0.248/29"
  tag                = "entry_subnet"
}

engines_priv_subnet = {
  cidr_block = "10.0.3.0/24"
  internet   = "disabled"
  tag        = "engines_priv_subnet"
}

core_priv_subnet = {
  cidr_block         = "10.0.2.0/24"
  cidr_reserved_block = "10.0.2.248/29"
  internet           = "enabled"
  tag                = "core_subnet"
}

bastion_ami       = "ami-005cb5968fa54fc60"
bastion_size      = "t3.xlarge"
bastion_disk_size = 150
bastion_networking = {
  eip_aloccation_id             = "eipalloc-02932a7a99d19ebc1"
  pub_domain                    = "bastion.lightrail-prod.railproj.net"
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  allowed_nfs_access_hosts_cidr = "10.0.0.0/16"
  bastion_vpn_port              = "29994"
}

control_host_ami       = "ami-0efa906ea4120549d"
control_host_size      = "t3.xlarge"
control_host_replicas  = 1
control_host_disk_size = 300
control_host_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
}

oxy_carrier_ami  = "ami-0194d4efa4b3c7d5f"
oxy_carrier_size = "t2.xlarge"
oxy_carrier_disk_size = 50
oxy_carrier_replicas = 0
oxy_carrier_source_dest_check = false
oxy_carrier_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
}

swg_host_ami       = "ami-0c4c0d5080d4a2807"
swg_host_size      = "m6i.large"
swg_host_replicas  = 0
swg_host_networking = {
  static_ip                    = "10.0.2.85"
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
}

f5_host_ami       = "ami-026683d91bc1bd48f"
f5_host_size      = "m5.large"
f5_host_replicas  = 0
f5_host_networking = {
  static_ip                    = "10.0.2.8"
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
}

ec2_endpoint_networking = {
  allowed_ep_access_hosts_cidr = "10.0.0.0/16"
}

k3s_node_replicas = {
  lb     = 1
  master = 3
  worker = 4
}

k3s_networking = {
  lb_vrrp_ip               = "10.0.2.249"
  allowed_kubeapi_cidr     = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  pod_network_block        = "10.129.0.0/16"
}

k3s_node_ami = {
  lb     = "ami-0596d08cef829df3e"
  master = "ami-0fd2d59e9df02d839"
  worker = "ami-0fd2d59e9df02d839"
}

k3s_node_size = {
  lb     = "t3.medium"
  master = "t3.xlarge"
  worker = "t3.xlarge"
}

k3s_disk_size = {
  master = 150
  worker = 300
  lb     = 150
}

engines_role_name    = "ec2_engines_role_lightrail-prod"
engines_profile_name = "ec2_engines_instance_profile_lightrail-prod"

lnx_metadata_ami        = "ami-0807b131bf0b3dccc"
lnx_metadata_size       = "c5.4xlarge"
lnx_metadata_disk_size  = 300
lnx_metadata_replicas   = 1
lnx_metadata_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto            = "tcp"
}

lnx_dataml_ami        = "ami-0194d4efa4b3c7d5f"
lnx_dataml_size       = "t3.xlarge"
lnx_dataml_disk_size  = 150
lnx_dataml_replicas   = 0
lnx_dataml_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_port_end          = "9000"
  app_ingress_proto             = "tcp"
}

lnx_pestatic_ami        = "ami-0a189f2bdc67971eb"
lnx_pestatic_size       = "t2.xlarge"
lnx_pestatic_disk_size  = 50
lnx_pestatic_replicas   = 0
lnx_pestatic_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_port_end          = "9000"
  app_ingress_proto             = "tcp"
}

lnx_extractor_ami        = "ami-0ef89c10ace566261"
lnx_extractor_size       = "t2.xlarge"
lnx_extractor_disk_size  = 50
lnx_extractor_replicas   = 0
lnx_extractor_networking = {
  allowed_ssh_access_hosts_cidr = "0.0.0.0/0"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_port_end          = "9000"
  app_ingress_proto             = "tcp"
}

win_eset_ami        = "ami-02a59de7c8f801b40"
win_eset_size       = "t3.xlarge"
win_eset_disk_size  = 150
win_eset_replicas   = 0
win_eset_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto             = "tcp"
}

win_bitdefender_ami        = "ami-031db362009976508"
win_bitdefender_size       = "t3.xlarge"
win_bitdefender_disk_size  = 150
win_bitdefender_replicas   = 0
win_bitdefender_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto             = "tcp"
}

win_windefender_ami        = "ami-08c53ca4112d956a5"
win_windefender_size       = "t3.xlarge"
win_windefender_disk_size  = 150
win_windefender_replicas   = 0
win_windefender_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto             = "tcp"
}

win_extractor_ami        = "ami-0ebd2155d8fd7d8a4"
win_extractor_size       = "c4.4xlarge"
win_extractor_disk_size  = 300
win_extractor_replicas   = 0
win_extractor_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto             = "tcp"
}

win_cdr_ami        = "ami-03afe6fec5238e540"
win_cdr_size       = "c4.4xlarge"
win_cdr_disk_size  = 300
win_cdr_replicas   = 0
win_cdr_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
  app_ingress_block             = "10.0.0.0/16"
  app_ingress_port              = "8080"
  app_ingress_proto             = "tcp"
}

win_ad_ami        = "ami-07da0250e5552b1e4"
win_ad_size       = "t2.large"
win_ad_disk_size  = 50
win_ad_replicas   = 0
win_ad_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
}

win_client_ami        = "ami-07da0250e5552b1e4"
win_client_size       = "t2.medium"
win_client_disk_size  = 50
win_client_replicas   = 0
win_client_networking = {
  allowed_rdp_access_hosts_cidr = "0.0.0.0/0"
  allowed_ssh_access_hosts_cidr = "10.0.0.0/16"
}
