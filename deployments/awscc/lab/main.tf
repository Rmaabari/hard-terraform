module "common_ssh" {
    source               = "../../../lib/awscc/ssh"
    ssh_key_name         = "master_key_${var.lab_name}"
    public_key_file_path = var.public_key_file
}

data "aws_route_table" "core_priv" {
  subnet_id = var.core_priv_subnet_id
}

# module "s3_endpoint" {
#     source      = "../../../lib/awscc/s3_endpoint"
#     vpc_id      = module.network.vpc_id
#     route_table_ids = [
#       module.network.entry_pub_subnet_route_table_id,
#       module.network.core_priv_subnet_route_table_id,
#     ]
#     tags = {
#         Name  = "oxygen_s3_endpoint",
#         "lab" = var.lab_name
#     }
# }

# module "ec2_endpoint" {
#     source      = "../../../lib/aws/ec2_endpoint"
#     vpc_id      = module.network.vpc_id
#     engines_priv_subnet_id = module.network.engines_priv_subnet_id
#     networking    = var.ec2_endpoint_networking
    
#     tags = {
#         Name  = "ec2_endpoint",
#         "lab" = var.lab_name
#     }
# }

# module "sqs_endpoint" {
#     source      = "../../../lib/aws/sqs_endpoint"
#     vpc_id      = module.network.vpc_id
#     route_tables_ids = {
#         "entry"                 = module.network.entry_pub_subnet_route_table_id
#         "core"                  = module.network.core_priv_subnet_route_table_id
#         subnet_id_core          = module.network.core_priv_subnet_id
#     }
#     tags = {
#         Name  = "sqs_endpoint",
#         "lab" = var.lab_name
#     }
# }

module "bastion_host" {
  source                = "../../../lib/awscc/bastion_host"
  image_id              = var.bastion_ami
  instance_type         = var.bastion_size
  vpc_id                = var.vpc_id
  subnet_id             = var.entry_pub_subnet_id
  ssh_key_name          = module.common_ssh.ssh_key_name
  networking            = var.bastion_networking 
  volume_size           = var.bastion_disk_size
  public_key_file_path  = var.public_key_file
  private_key_file_path = var.private_key_file
  tags                  = {
    Name = "bastion"
    lab  = var.lab_name
  }

  # Pass the replicas variable in
  oxy_carrier_replicas  = var.oxy_carrier_replicas
}


module "control_host" {
    source        = "../../../lib/awscc/control_host"
    ami           = var.control_host_ami
    instance_type = var.control_host_size
    vpc_id        = var.vpc_id
    subnet_id     = var.core_priv_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    networking    = var.control_host_networking
    disk_size     = var.control_host_disk_size
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    replicas      = var.control_host_replicas
    lab_name       = var.lab_name
    tags          = {
        Name = "core_control_host",
        "lab"   = var.lab_name
    }
}

module "oxy_carrier" {
    source        = "../../../lib/awscc/oxy_carrier"
    ami           = var.oxy_carrier_ami
    instance_type = var.oxy_carrier_size
    vpc_id        = var.vpc_id
    subnet_id     = var.entry_pub_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    networking    = var.oxy_carrier_networking
    source_dest_check = var.oxy_carrier_source_dest_check
    disk_size     = var.oxy_carrier_disk_size
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    oxy_carrier_network_interface_id = var.oxy_carrier_network_interface_id
    replicas      = var.oxy_carrier_replicas
    lab_name      = var.lab_name
    tags          = {
        Name = "oxy_carrier",
        "lab" = var.lab_name
    }
}

module "k3s_core_cluster" {
    source         = "../../../lib/awscc/k3s"
    cluster_name   = "core-k3s"
    ebs_csi_policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    vpc_id         = var.vpc_id
    subnet_id      = var.core_priv_subnet_id
    amis           = var.k3s_node_ami
    instance_types = var.k3s_node_size
    networking     = var.k3s_networking
    replicas       = var.k3s_node_replicas
    disk_sizes     = var.k3s_disk_size 
    ssh_key_name   = module.common_ssh.ssh_key_name
    lab_name       = var.lab_name
    tags           = {
        Name = "core_k3s_cluster"
        "lab"   =  var.lab_name
    }
}

### TO BE CONTINUED
# module "eks" {
#     source             = "../../../lib/awscc/eks"
#     subnet_ids         = module.network.core_priv_subnet_id
#     key_name           = module.common_ssh.ssh_key_name
#     vpc_id             = module.network.vpc_id
# } 

module "ec2_endpoint" {
  source              = "../../../lib/awscc/endpoints"
  vpc_id              = var.vpc_id
  subnet_ids          = [var.core_priv_subnet_id]
  route_table_ids     = [data.aws_route_table.core_priv.id]
  private_dns_enabled = true
  region              = var.region
  tags = {
    "Name"        = "ec2-vpc-endpoint",
    "lab"         = var.lab_name
  }
}


module "windows-sqs" {
  source = "../../../lib/awscc/sqs"
  lab_name       = var.lab_name
  anti_virus_sqs = var.anti_virus_sqs
}


module "engines_role" {
    source              = "../../../lib/awscc/roles"
    profile_name  = var.engines_profile_name
    role_name     = var.engines_role_name
    subnet_id     = var.engines_priv_subnet_id
    lab_name      = var.lab_name
    tags          = {
        Name       = var.engines_role_name,
        "type"     = "engine",
        "os"       = "lnx",
        "lab"      = var.lab_name
    }
}

module "lnx_metadata" {
    source        = "../../../lib/awscc/engines/lnx_metadata"
    ami           = var.lnx_metadata_ami
    instance_type = var.lnx_metadata_size
    replicas      = var.lnx_metadata_replicas
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    disk_size     = var.lnx_metadata_disk_size
    networking    = var.lnx_metadata_networking
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    tags          = {
        Name = "FileMetadata",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "lnx",
        "provider" = "aws",
        "engine-type" = "FileMetadata",
        "type" = "engine"
    }
}

module "lnx_dataml" {
    source        = "../../../lib/awscc/engines/lnx_dataml"
    ami           = var.lnx_dataml_ami
    instance_type = var.lnx_dataml_size
    replicas      = var.lnx_dataml_replicas
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    disk_size     = var.lnx_dataml_disk_size 
    networking    = var.lnx_dataml_networking
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    tags          = {
        Name = "FileMetadata",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "lnx",
        "provider" = "aws",
        "engine-type" = "DataML",
        "type" = "engine"
    }
}

module "lnx_pestatic" {
    source        = "../../../lib/aws/engines/lnx_pestatic"
    ami           = var.lnx_pestatic_ami
    instance_type = var.lnx_pestatic_size
    replicas      = var.lnx_pestatic_replicas
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    disk_size     = var.lnx_pestatic_disk_size 
    networking    = var.lnx_pestatic_networking
    instance_profile = module.engines_role.aws_instance_profile_name
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    tags          = {
        Name       = "pestatic",
        "lab"      = var.lab_name,
        "type"     = "engine",
        "os"       = "lnx",
        "provider" = "bengurion"
    }
}

module "lnx_extractor" {
    source        = "../../../lib/awscc/engines/lnx_extractor"
    ami           = var.lnx_extractor_ami
    instance_type = var.lnx_extractor_size
    replicas      = var.lnx_extractor_replicas
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    ssh_key_name  = module.common_ssh.ssh_key_name
    disk_size     = var.lnx_extractor_disk_size 
    networking    = var.lnx_extractor_networking
    instance_profile = module.engines_role.aws_instance_profile_name
    public_key_file_path  = var.public_key_file
    private_key_file_path = var.private_key_file
    tags          = {
        Name          = "ArchiveExtractor",
        "lab"         = var.lab_name,
        "type"        = "engine",
        "os"          = "lnx",
        "provider"    = "aws",
        "engine-type" = "ArchiveExtractor",
        "internet"    = "false"
    }
}

module "win_eset" {
    source        = "../../../lib/awscc/engines/win_common"
    ami           = var.win_eset_ami
    instance_type = var.win_eset_size
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    disk_size     = var.win_eset_disk_size 
    networking    = var.win_eset_networking
    public_key_file_path  = var.public_key_file
    eng_name      = "ESET"
    replicas      = var.win_eset_replicas
    tags          = {
        Name = "ESET",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "win",
        "provider" = "aws",
        "engine-type" = "ESET"
    }
}

module "win_bitdefender" {
    source        = "../../../lib/awscc/engines/win_common"
    ami           = var.win_bitdefender_ami
    instance_type = var.win_bitdefender_size
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    disk_size     = var.win_bitdefender_disk_size 
    networking    = var.win_bitdefender_networking
    public_key_file_path  = var.public_key_file
    eng_name      = "BitDefender"
    replicas      = var.win_bitdefender_replicas
    tags          = {
        Name = "BitDefender",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "win",
        "provider" = "aws",
        "engine-type" = "BitDefender"
    }
}

module "win_windefender" {
    source        = "../../../lib/awscc/engines/win_common"
    ami           = var.win_windefender_ami
    instance_type = var.win_windefender_size
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    disk_size     = var.win_windefender_disk_size 
    networking    = var.win_windefender_networking
    public_key_file_path  = var.public_key_file
    eng_name      = "MSDefender"
    replicas      = var.win_windefender_replicas
    tags          = {
        Name = "MSDefender",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "win",
        "provider" = "aws",
        "engine-type" = "MSDefender"
    }
}

module "win_extractor" {
    source        = "../../../lib/awscc/engines/win_common"
    ami           = var.win_extractor_ami
    instance_type = var.win_extractor_size
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    disk_size     = var.win_extractor_disk_size 
    networking    = var.win_extractor_networking
    public_key_file_path  = var.public_key_file
    eng_name      = "ArchiveExtractor"
    replicas      = var.win_extractor_replicas
    tags          = {
        Name = "ArchiveExtractor",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "win",
        "provider" = "aws",
        "engine-type" = "ArchiveExtractor"
    }
}

module "win_cdr" {
    source        = "../../../lib/awscc/engines/win_common"
    ami           = var.win_cdr_ami
    instance_type = var.win_cdr_size
    vpc_id        = var.vpc_id
    subnet_id     = var.engines_priv_subnet_id
    disk_size     = var.win_cdr_disk_size 
    networking    = var.win_cdr_networking
    public_key_file_path  = var.public_key_file
    eng_name      = "CDR"
    replicas      = var.win_cdr_replicas
    tags          = {
        Name = "CDR",
        "lab"   = var.lab_name,
        "type"  = "engine",
        "os"    = "win",
        "provider" = "aws",
        "engine-type" = "CDR"
    }
}

# module "win_smtpr" {
#     source        = "../../../lib/aws/engines/win_smtpr"
#     ami           = var.win_smtpr_ami
#     instance_type = var.win_smtpr_size
#     vpc_id        = module.network.vpc_id
#     subnet_id     = module.network.engines_priv_subnet_id
#     disk_size     = var.win_smtpr_disk_size 
#     networking    = var.win_smtpr_networking
#     public_key_file_path  = var.public_key_file
#     eng_name      = "engine-win-smtpr"
#     replicas      = var.win_smtpr_replicas
#     tags          = {
#         "lab"     = var.lab_name,
#         "type"    = "engine-nfs",
#         "os"      = "win",
#         "purpose" = "smtprelay"
#     }
# }

module "active_directory" {
    source        = "../../../lib/aws/win_ec2"
    ami           = var.win_ad_ami
    instance_type = var.win_ad_size
    vpc_id        = var.vpc_id
    subnet_id     = var.entry_pub_subnet_id
    disk_size     = var.win_ad_disk_size 
    networking    = var.win_ad_networking
    public_key_file_path  = var.public_key_file
    purpose       = "cpe-dc"
    replicas      = var.win_ad_replicas
    tags          = {
        "lab"     = var.lab_name,
        "type"    = "cpe",
        "os"      = "win",
        "purpose" = "dc"
    }
}

module "client" {
    source        = "../../../lib/aws/win_ec2"
    ami           = var.win_client_ami
    instance_type = var.win_client_size
    vpc_id        = var.vpc_id
    subnet_id     = var.entry_pub_subnet_id
    disk_size     = var.win_client_disk_size 
    networking    = var.win_client_networking
    public_key_file_path  = var.public_key_file
    purpose       = "cpe-client"
    replicas      = var.win_client_replicas
    tags          = {
        "lab"     = var.lab_name,
        "type"    = "cpe",
        "os"      = "win"
        "purpose" = "client"
    }
}

# module "swg_host" {
#     source        = "../../../lib/aws/swg_host"
#     ami           = var.swg_host_ami
#     instance_type = var.swg_host_size
#     vpc_id        = module.network.vpc_id
#     subnet_id     = module.network.core_priv_subnet_id
#     ssh_key_name  = module.common_ssh.ssh_key_name
#     networking    = var.swg_host_networking
#     disk_size     = var.swg_host_disk_size
#     public_key_file_path  = var.public_key_file
#     private_key_file_path = var.private_key_file
#     replicas      = var.swg_host_replicas
#     lab_name       = var.lab_name
#     tags          = {
#         Name = "swg_host",
#         "lab"   = var.lab_name
#     }
# }

# module "f5_host" {
#     source        = "../../../lib/aws/f5_host"
#     ami           = var.f5_host_ami
#     instance_type = var.f5_host_size
#     vpc_id        = module.network.vpc_id
#     subnet_id     = module.network.core_priv_subnet_id
#     ssh_key_name  = module.common_ssh.ssh_key_name
#     networking    = var.f5_host_networking
#     disk_size     = var.f5_host_disk_size
#     public_key_file_path  = var.public_key_file
#     private_key_file_path = var.private_key_file
#     replicas      = var.f5_host_replicas
#     lab_name       = var.lab_name
#     tags          = {
#         Name = "f5_host",
#         "lab"   = var.lab_name
#     }
# }