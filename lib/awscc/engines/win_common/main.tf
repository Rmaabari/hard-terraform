resource "awscc_ec2_instance" "main" {
  count           = var.replicas
  image_id        = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_group_ids = ["${awscc_ec2_security_group.main_win.id}"]


  block_device_mappings = [
    {
      device_name = var.device_name  

      ebs = {
        volume_size           = var.disk_size
        volume_type           = var.volume_type
        delete_on_termination = true
      }
    }
  ]


user_data = base64encode(<<-EOF
  <powershell>
    net user Administrator HollyBananus76445
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Set-Service -Name sshd -StartupType "Automatic"
    Start-Service sshd
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    New-ItemProperty -Path "HKLM:\\SOFTWARE\\OpenSSH" -Name "DefaultShell" -Value "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe" -PropertyType "String" -Force
    Get-Content -Path "C:\\ProgramData\\ssh\\administrators_authorized_keys" -ErrorAction SilentlyContinue | Out-Null
    Add-Content -Path "C:\\ProgramData\\ssh\\administrators_authorized_keys" -Value "${data.template_file.ssh_pubkey.rendered}"
    icacls.exe "C:\\ProgramData\\ssh\\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
  </powershell>
EOF
)

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "${var.eng_name}-${count.index}" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}





# resource "aws_instance" "main" {
#   count           = var.replicas
#   ami                         = var.ami
#   instance_type               = var.instance_type
#   vpc_security_group_ids      = ["${aws_security_group.main.id}"]
#   subnet_id                   = var.subnet_id
#   root_block_device {
#       volume_size = var.disk_size
#       volume_type = "gp3"
#   }
#   #user_data_replace_on_change = true
#   user_data = <<-EOF
#   <powershell>
#     net user Administrator HollyBananus76445
#     Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
#     Set-Service -Name sshd -StartupType "Automatic"
#     Start-Service sshd
#     Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#     New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType "String" -Force
#     Get-Content -Path "C:\ProgramData\ssh\administrators_authorized_keys" -ErrorAction SilentlyContinue | Out-Null ; Add-Content -Path "C:\ProgramData\ssh\administrators_authorized_keys" -Value "${data.template_file.ssh_pubkey.rendered}"
#     icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
#   </powershell>
#   EOF

#   tags = merge(var.tags, {Name = "${var.eng_name}-${count.index}"})
# }