#
# COMMON VARS
#

variable "region" {
  type = string
  description = "default region where infra will be deployed"
  default = "eu-central-1"
}

variable "public_key_file" {
  type        = string
  description = "path to the ssh pubkey. used for passwordless connection to all nodes"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_file" {
    type        = string
    description = "ssh key file for access cluster nodes on local pc"
    default     = "~/.ssh/id_rsa"
}

variable "lab_name" {
  type        = string
  description = "name of the current deployment: dev, stg, etc..."
}

variable "domain" {
  type        = string
  description = "root domain of the deployment"
}

variable "anti_virus_sqs" {
  description = "Whether to create SQS queues for anti-virus integrations"
  type        = bool
  default     = false
}

#
# NETWORK LAYER VARS
#

variable "enable_vpc_dnsnames" {
  type        = bool
  description = "enable dns hostnames for the vpc"
  default     = false
}

variable "cidr_vpc_block" {
  type        = string
  description = "ip block for vpc"
}

variable "vpc_id" {
  type        = string
  description = "ID of existing VPC"
}

variable "entry_pub_subnet_id" {
  type        = string
  description = "ID of existing entry public subnet"
}

variable "engines_pub_subnet_id" {
  type        = string
  description = "ID of existing engines public subnet"
}

variable "engines_priv_subnet_id" {
  type        = string
  description = "ID of existing engines private subnet"
}

variable "core_priv_subnet_id" {
  type        = string
  description = "ID of existing core private subnet"
}

variable "cpe_priv_subnet_id" {
  type        = string
  description = "ID of existing cpe private subnet"
  default     = ""
}

variable "entry_pub_subnet" {
  type        = map(string)
  description = "pub subnet for vpn. required keys: cidr_block, cidr_reserved_block."
}

variable "engines_pub_subnet" {
  type        = map(string)
  description = "pub subnet for engines.required keys: cidr_block, cidr_reserved_block."
}

variable "engines_priv_subnet" {
  type        = map(string)
  description = "priv subnet for engines.required keys: cidr_block, cidr_reserved_block."
}

variable "core_priv_subnet" {
  type        = map(string)
  description = "priv subnet for core. required keys: cidr_block, cidr_reserved_block."
}

variable "cpe_priv_subnet" {
  type        = map(string)
  description = "priv subnet for cpe. required keys: cidr_block, cidr_reserved_block."
  default = {}
}
# EC2 VPC ENDPOINT

variable "ec2_endpoint_networking" {
  type        = map(string)
  description = "ip addresses used by ec2 vpc endpoint"
}

# BASTION

variable "bastion_networking" {
  type        = map(string)
  description = "ip addresses used by bastion"
}

variable "bastion_ami" {
  type        = string
  description = "ami for bastion"
}

variable "bastion_size" {
  type        = string
  description = "ec2 size of bastion host"
}

variable "bastion_disk_size" {
  type        = string
  description = "ec2 disk size of bastion host"
}

# CONTROL HOST

variable "control_host_networking" {
  type        = map(string)
  description = "ip addresses used by bastion"
}

variable "control_host_ami" {
  type        = string
  description = "ami for control host"
}

variable "control_host_size" {
  type        = string
  description = "ec2 size of control host"
}

variable "control_host_disk_size" {
  type        = string
  default     = "10"
  description = "ec2 disk size of control host"
}

variable "control_host_replicas" {
  type        = number
  description = "how much replicas to install"
}


# OXY CARRIER

variable "oxy_carrier_networking" {
  type        = map(string)
  description = "ip addresses used by bastion"
}

variable "oxy_carrier_ami" {
  type        = string
  description = "ami for oxy_carrier"
}

variable "oxy_carrier_size" {
  type        = string
  description = "ec2 size of oxy_carrier"
}

variable "oxy_carrier_disk_size" {
  type        = string
  default     = "10"
  description = "ec2 disk size of oxy_carrier"
}

variable "oxy_carrier_replicas" {
  type        = number
  description = "how much replicas to install"
}

variable "oxy_carrier_source_dest_check" {
  type        = bool
  default     = true
  description = "Whether to enable source/destination checks for the oxy carrier"
}

variable "oxy_carrier_network_interface_id" {
  type        = string
  description = "The network interface ID for the oxy_carrier instance."
  default     = ""  // Or you can choose a meaningful default
}


# k3s CLUSTER

variable "k3s_networking" {
  type        = map(string)
  description = "ip addresses used in k3s cluster"
}

variable "k3s_node_replicas" {
  type        = map(number)
  description = "replicas of k3s nodes"
}

variable "k3s_node_ami" {
  type        = map(string)
  description = "ami for k3s cluster nodes"
}

variable "k3s_node_size" {
  type        = map(string)
  description = "ec2 instance sizes of k3s cluster nodes"
}

variable "k3s_disk_size" {
  type        = map(number)
  description = "ec2 disk sizes of k3s cluster nodes"
}

# Engines  : roles

variable "engines_profile_name" {
  type = string
}

variable "engines_role_name" {
  type = string
}

# Engines : lnx_metadata

variable "lnx_metadata_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "lnx_metadata_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "lnx_metadata_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "lnx_metadata_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "lnx_metadata_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : lnx_dataml

variable "lnx_dataml_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "lnx_dataml_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "lnx_dataml_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "lnx_dataml_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "lnx_dataml_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : lnx_pestatic

variable "lnx_pestatic_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "lnx_pestatic_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "lnx_pestatic_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "lnx_pestatic_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "lnx_pestatic_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : lnx_extractor

variable "lnx_extractor_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "lnx_extractor_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "lnx_extractor_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "lnx_extractor_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "lnx_extractor_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : win_eset

variable "win_eset_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_eset_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_eset_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_eset_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_eset_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : win_bitdefender

variable "win_bitdefender_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_bitdefender_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_bitdefender_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_bitdefender_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_bitdefender_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : win_windefender

variable "win_windefender_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_windefender_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_windefender_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_windefender_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_windefender_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : win_extractor

variable "win_extractor_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_extractor_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_extractor_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_extractor_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_extractor_replicas" {
  type        = number
  description = "how much replicas to install"
}

# Engines : win_cdr

variable "win_cdr_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_cdr_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_cdr_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_cdr_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_cdr_replicas" {
  type        = number
  description = "how much replicas to install"
}

# # Engines : win_smtpr


# CPE

# CPE : active dir

variable "win_ad_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_ad_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_ad_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_ad_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_ad_replicas" {
  type        = number
  description = "how much replicas to install"
}

# CPE : client

variable "win_client_networking" {
  type        = map(string)
  description = "ip addresses used by the engine"
}

variable "win_client_ami" {
  type        = string
  description = "ami for linux engine host"
}

variable "win_client_size" {
  type        = string
  description = "ec2 size of linux engine host"
}

variable "win_client_disk_size" {
  type        = string
  description = "ec2 disk size of the engine"
}

variable "win_client_replicas" {
  type        = number
  description = "how much replicas to install"
}


# SWG HOST

variable "swg_host_networking" {
  type        = map(string)
  description = "ip addresses used by bastion"
}

variable "swg_host_ami" {
  type        = string
  description = "ami for swg host"
}

variable "swg_host_size" {
  type        = string
  description = "ec2 size of swg host"
}

variable "swg_host_disk_size" {
  type        = string
  default     = "10"
  description = "ec2 disk size of swg host"
}

variable "swg_host_replicas" {
  type        = number
  description = "how much replicas to install"
}

# F5 HOST

variable "f5_host_networking" {
  type        = map(string)
  description = "ip addresses used by bastion"
}

variable "f5_host_ami" {
  type        = string
  description = "ami for f5 host"
}

variable "f5_host_size" {
  type        = string
  description = "ec2 size of f5 host"
}

variable "f5_host_disk_size" {
  type        = string
  default     = "10"
  description = "ec2 disk size of f5 host"
}

variable "f5_host_replicas" {
  type        = number
  description = "how much replicas to install"
}