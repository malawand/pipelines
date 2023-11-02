# 📖 README
This repo helps build a pipeline to deploy a virtual machine to an ESXi host, and the code required to automate a deployment of an application.

- [x] Use the esxi-vm-packer to build the GO script to pack and deploy the virtual machine into ESXi
- [x] Once the VM has been deployed into ESXi, utilize the ansible playbook, "poweronvm.yml", to power on the new VM and update the inventory file with the VM of the new VM. This is how ansible will know to deploy other playbooks to the newly deployed VM
- [x] Once the VM is powered on and the inventory file has been updated, use the "playbook.yml" ansible playbook to deploy your applications and configure the machine however you wish
- [x] The jenkins directory contains the pipeline file to create the pipeline in Jenkins. The file is in groovy syntax, hence .gvy file extension