#!/bin/bash

# Add /usr/local/bin to the PATH
export PATH=$PATH:/usr/local/bin

echo "Testing 1" > /opt/test1.txt

# No password needed for privilege escalation
cat <<EOF > /etc/sudoers.d/{{ index .PackerVars "vm_username" }}
{{ index .PackerVars "vm_username" }} ALL=(ALL) NOPASSWD:ALL
EOF

echo "Testing 2" > /opt/test2.txt


# Add authorized_keys for root
# test -d /root/.ssh || mkdir /root/.ssh
# cat <<EOF > /root/.ssh/authorized_keys
# {{ index .PackerVars "vm_ssh_public_key" }}
# EOF
# chmod 0700 /root/.ssh
# chmod 0600 /root/.ssh/authorized_keys

# echo "Testing 3" > /opt/test3.txt


# # Allow SSH via public keys signed by a trusted SSH CA
# cat <<EOF > /etc/ssh/trusted-ca.pem
# {{ index .PackerVars "vm_ssh_ca_public_key" }}
# EOF

# echo "Testing 3" > /opt/test4.txt


# mkdir /etc/ssh/auth_principals
# echo root > /etc/ssh/auth_principals/root
# echo {{ index .PackerVars "vm_username" }} > /etc/ssh/auth_principals/{{ index .PackerVars "vm_username" }}

# cat <<EOF >> /etc/ssh/sshd_config
# AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u
# KbdInteractiveAuthentication no
# PasswordAuthentication yes
# TrustedUserCAKeys /etc/ssh/trusted-ca.pem
# EOF

# Install ansible
sudo apt-get update
sudo apt-get install -y python3-pip
sudo pip3 install --upgrade pip
sudo apt install --upgrade ansible -y
sudo ansible-galaxy collection install --timeout 180 community.general

# Add net.ifnames=0 to the kernel boot parameters
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 net.ifnames=0"/' /etc/default/grub
update-grub

# Setup ZFS installation pre-reqs
# Instructions: https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html#installation
sed -r -i '/^deb(.*) contrib$/!s/^deb(.*)$/deb\1 contrib/g' /etc/apt/sources.list
cat <<EOF > /etc/apt/sources.list.d/bookworm-backports.list
deb http://deb.debian.org/debian bookworm-backports main contrib
deb-src http://deb.debian.org/debian bookworm-backports main contrib
EOF

cat <<EOF > /etc/apt/preferences.d/90_zfs
Package: src:zfs-linux
Pin: release n=bookworm-backports
Pin-Priority: 990
EOF

sudo apt-get update
sudo apt-get install -y dpkg-dev linux-headers-generic linux-image-generic

# Install Docker
sudo for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo docker network create elastic
sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:8.10.3
sudo docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.10.3

sudo sysctl -w vm.max_map_count=262144
sudo docker run --name es03 --net elastic -p 9200:9200 -it  docker.elastic.co/elasticsearch/elasticsearch:8.10.3

# Installing Kibana
# sudo docker pull docker.elastic.co/kibana/kibana:8.10.3
# sudo docker run -d --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.10.3
sudo docker login -u malwand94/kibana -u "Ny8-LSY-SFL-W9e!-11"


# Usernae: elastic
# Password: liMu*oZaSsoIkSAucytP
