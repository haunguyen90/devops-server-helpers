#!/bin/bash
#==========================
#
#       SET OF COMMAND LINES FOR SETUP UBUNTU SERVER
#       AND START METEOR IN PRODUCTION
#
#==========================

# MANUAL SETUP

# NVM & NODE

cd ~
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
bash install_nvm.sh
source ~/.profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm --version

# CHECK PORT
#sudo iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 3000
#sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3000
#sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

#MONGODB
#https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
sudo apt update
sudo apt install -y mongodb
sudo systemctl status mongodb
# sudo service mongodb status

# PM2
npm install pm2 -g

#FORWARD PORT 80 TO 3000
sudo iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 3000
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

#export METEOR_CORDOVA_COMPAT_VERSION_IOS="v40"
#export METEOR_CORDOVA_COMPAT_VERSION_ANDROID="v40"
#export METEOR_CORDOVA_COMPAT_VERSION_EXCLUDE=*

export ROOT_URL='https://www.mywebsite.com'
export MONGO_URL='mongodb://mongouser:mongopassword@localhost:27017/projectdb'
export MONGO_OPLOG_URL='mongodb://oploguser:oplogpassword@localhost:27017/local?authSource=projectdb'
#export PORT='3000'
export METEOR_SETTINGS=$(cat /path/to/settings.json )
export NODE_ENV=production
#export KADIRA_PROFILE_LOCALLY=1
#export KADIRA_APP_ID=your_nodechef.com_app_id
#export KADIRA_APP_SECRET=your_nodechef.com_secret

cd /path/to/upload
rm -rf bundle
tar -xvzf *.tar.gz

rm -rf /path/to/production
mkdir /path/to/production

cd /path/to/upload/bundle
mv * /path/to/production

cd /path/to/production/programs/server
npm install --production
#npm install stripe
#npm install paypal-rest-sdk
#npm install sendgrid

cd /path/to/production/
pm2 start main.js --name='yourappname'
pm2 save
