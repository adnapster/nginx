cd ../..
sudo git init
sudo git pull https://cups:SAIbaba7861@jci.visualstudio.com/BE%20SWM/_git/jcibe-swm-nginx sandbox
cd dockerCompose/sandbox
sudo docker-compose stop
sudo docker-compose build
sudo docker-compose up -d