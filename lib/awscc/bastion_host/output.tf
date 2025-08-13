output "nodes" {
  value = [
    {
      # turn the awscc tags list back into a map…
      name = lookup(
        { for t in awscc_ec2_instance.main.tags : t.key => t.value },
        "Name",
        ""
      )

      public_ip  = var.networking["pub_domain"]
      vpn_port   = var.networking["bastion_vpn_port"]
      private_ip = awscc_ec2_instance.main.private_ip
    }
  ]
}
