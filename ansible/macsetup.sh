# /bin/bash
brew install hudochenkov/sshpass/sshpass

# Password based auth:
# ansible -i inventory example -m ping -u malawand -k 
# With ansible.cfg
# ansible example -m ping -u malawand
