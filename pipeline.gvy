pipeline{
    agent any
    stages{
        stage('Fetching Code from Git...'){
            steps{
                git branch: 'main', credentialsId: 'aa903527-77a4-45e9-b58a-92d399eb2eeb', url: 'https://github.com/malawand/esxivmdeployment.git'
            }
        }
        stage('Deploying OS into ESXi...'){
            steps {
                dir('esxi-vm-packer'){
                    sh '$WORKSPACE/esxi-vm-packer/builder -n testWithJenkins -packer-path /opt/homebrew/bin/packer -r bookworm'       
                }
            }
        }
    }
}
