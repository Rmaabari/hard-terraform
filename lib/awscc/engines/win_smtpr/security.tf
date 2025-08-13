resource "aws_security_group" "main" {
    name    = "${var.eng_name}"
    vpc_id  = var.vpc_id
    # remove(or change to limit) in production env
    ingress {
        cidr_blocks = [ "${var.networking["allowed_smtp_access_hosts_cidr"]}" ]
        from_port = 25
        to_port  =  25
        protocol = "tcp"
    }

    # remove(or change to limit) in production env
    ingress {
        cidr_blocks = [ "${var.networking["allowed_ssh_access_hosts_cidr"]}" ]
        from_port = 22
        to_port  =  22
        protocol = "tcp"
    }

    # remove(or change to limit) in production env
    ingress {
        cidr_blocks = [ "${var.networking["allowed_rdp_access_hosts_cidr"]}" ]
        from_port = 3389
        to_port  =  3389
        protocol = "tcp"
    }

    ingress {
        cidr_blocks = [ "${var.networking["app_ingress_block"]}" ]
        from_port = "${var.networking["app_ingress_port"]}"
        to_port  =  "${var.networking["app_ingress_port"]}"
        protocol = "${var.networking["app_ingress_proto"]}"
    }
    # allow all VPC traffic
    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
    }


    // remove the default rule
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port   = 0
        protocol  = "-1"
    }

    tags                        = var.tags
}