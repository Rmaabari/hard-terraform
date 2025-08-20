resource "awscc_ec2_key_pair" "main" {
  key_name            = local.ssh_key_name
  public_key_material = file(var.public_key_file_path)

  tags = [
    for k, v in local.tags : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    # don’t replace the key-pair resource just because AWS
    # returns a slightly different fingerprint or metadata
    ignore_changes = [
      public_key_material,
    ]
  }
}