ssh-keygen -f ./id_rsa -t rsa -b 4096 -C 'bastion' -N ''
sudo docker image build . -t bastion-server
