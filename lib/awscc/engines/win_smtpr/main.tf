resource "aws_eip_association" "eip_assoc" {
  count         = var.replicas == 1 ? 1 : 0
  instance_id   = aws_instance.main[0].id // Assuming you want to associate with the first instance
  allocation_id = var.networking["eip_allocation_id"]
}

resource "aws_instance" "main" {
  count                       = var.replicas
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  subnet_id                   = var.subnet_id
  root_block_device {
      volume_size = var.disk_size
      volume_type = "gp3"
  }
  #user_data_replace_on_change = true
  user_data = <<-EOF
  <powershell>
    net user Administrator HollyBananus76445
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Set-Service -Name sshd -StartupType "Automatic"
    Start-Service sshd
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType "String" -Force
    Get-Content -Path "C:\ProgramData\ssh\administrators_authorized_keys" -ErrorAction SilentlyContinue | Out-Null ; Add-Content -Path "C:\ProgramData\ssh\administrators_authorized_keys" -Value "${data.template_file.ssh_pubkey.rendered}"
    icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
    Install-WindowsFeature NFS-Client
  </powershell>
  <persist>true</persist>
  <frequency>always</frequency> 
  EOF

  tags = merge(var.tags, {Name = "${var.eng_name}"})
}