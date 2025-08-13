resource "aws_security_group" "main" {
    name    = "lnx pestatic rules"
    vpc_id  = var.vpc_id
    ingress {
        cidr_blocks = [ "${var.networking["allowed_ssh_access_hosts_cidr"]}" ]
        from_port = 22
        to_port  =  22
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = [ "${var.networking["app_ingress_block"]}" ]
        from_port = "${var.networking["app_ingress_port"]}"
        to_port  =  "${var.networking["app_ingress_port_end"]}"
        protocol = "${var.networking["app_ingress_proto"]}"
    }

    // remove the default rule
    egress {
        cidr_blocks = [ "${var.networking["app_ingress_block"]}" ]
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
    }

    tags                        = var.tags
}