pipeline{
    agent any
    stages{
        stage('Fetching Code from Git...'){
            steps{
                git branch: 'main', credentialsId: 'aa903527-77a4-45e9-b58a-92d399eb2eeb', url: 'https://github.com/malawand/esxivmdeployment.git'
            }
        }
        stage('Deploying Debian VM into ESXi...'){
            steps {
                dir('esxi-vm-packer'){
                    sh '$WORKSPACE/esxi-vm-packer/builder -n demo-kibana -packer-path /opt/homebrew/bin/packer -r bookworm'       
                }
            }
        }   
        stage('Powering on new VM...'){
            steps {
                dir('ansible'){
                    sh 'ansible-playbook poweronvm.yml -i inventory -u root --connection-password-file password.txt'
                    sh 'export ANSIBLE_HOST_KEY_CHECKING=False'
                    sh 'sshpass -f $WORKSPACE/ansible/password.txt scp root@10.2.11.3:/tmp/dockerinventory $WORKSPACE/ansible/dockerinventory'
                }
            }
        }          
        stage('Deploying Kibana & Elastic Docker Containers...'){
            steps {
                dir('ansible'){
                    sh 'ansible-playbook playbook.yml -i dockerinventory -u malawand --connection-password-file vmpassword.txt'       
                }
            }
        }  
    }
}