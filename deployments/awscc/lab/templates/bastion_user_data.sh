#!/bin/bash -x

######################
## Install Packages ##
######################
yum update -y
yum install -y bind-utils tcpdump vim git python3-pip

###############
# Basic Stuff #
################

# Improve Shell History
cat <<'EOF' >> /etc/bash.bashrc
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=""
export HISTSIZE=50000
declare -x HISTIGNORE=' *'
EOF

# Configure Hostname
hostnamectl set-hostname "${hostname}"

# Add Hostname to /etc/hosts
sed -i "/^127.0.0.1.*localhost/a 127.0.0.1 ${hostname}" /etc/hosts


################
## SET UP SSH ##
################

# Create a new folder for the log files
mkdir /var/log/bastion

# Allow ec2-user only to access this folder and its content
chown ec2-user:ec2-user /var/log/bastion
chmod -R 770 /var/log/bastion
setfacl -Rdm other:0 /var/log/bastion

# Update sshd default port to public_ssh_port
sed -i "s/#Port 22/Port ${public_ssh_port}/g" /etc/ssh/sshd_config

# Remove SSHD DNS R Lookup
sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

# Restart the SSH service to apply /etc/ssh/sshdf_config modifications.
service sshd restart


##############################
## INSTALL SECURITY UPDATES ##
##############################

# Security updates are installed by yum. If script is updated (package util-linux)
# then the setuid bit needs to be recovered. Otherwise clients can not loging.

cat > /usr/bin/bastion/yum_update << 'EOF'
#!/usr/bin/env bash

yum -y update --security

chown root:ec2-user /usr/bin/script
chmod g+s /usr/bin/script

EOF

chmod 700 /usr/bin/bastion/yum_update


###########################################
## SCHEDULE SCRIPTS AND SECURITY UPDATES ##
###########################################

cat > ~/mycron << EOF
0 0 * * * /usr/bin/bastion/yum_update
EOF
crontab ~/mycron
rm ~/mycron