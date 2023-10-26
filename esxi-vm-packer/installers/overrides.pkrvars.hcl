#
# ESX variables
#
esx_server    = "10.2.11.3" # ESX host
esx_username  = "root" # ESX user with admin and SSH access 
esx_password  = "savqi9-mewces-nAcjod!-11" # ESX user password
esx_network   = "Data NW" # ESX virtual network name for the VM
esx_datastore = "SSD - 2" # ESX datastore name to place the VM's VMDK files

#
# VM variables
#
vm_username       = "malawand" # VM user to create
vm_password       = "Cisco123!" # VM user's password
vm_ssh_public_key = "" # SSH public key to place into the VM user's SSH authorized_keys file
