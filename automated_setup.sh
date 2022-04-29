#!/bin/bash

sudo dpkg --configure -a
sudo chmod +x variables.sh
source variables.sh

# updates the server
echo
echo "Updating the system...."
echo
sudo apt-get update -y
echo
echo "Update completed......."
echo
sleep 1

# install php and composer
echo
echo "Installing PHP...."
echo
sudo apt install php$VERSION-fpm php$VERSION-mysql -y
sudo apt-get install composer -y
sudo apt install php$VERSION-cli php$VERSION-fpm php$VERSION-json php$VERSION-pdo php$VERSION-mysql php$VERSION-zip php$VERSION-gd  php$VERSION-mbstring php$VERSION-curl php$VERSION-xml php$VERSION-bcmath php$VERSION-json -y
echo
echo "PHP installation Completed..."
echo
sleep 1

# Mysql configurations
echo
sudo chmod +x mongodb.sh
source mysql.sh
echo
sleep 1

# Nginx Install
echo
echo "Installing Nginx and Final Setup...."
echo
sudo apt-get install nginx -y
sudo ufw allow 'Nginx HTTP'
echo
echo
sleep 1

#clone project and configure
echo
echo "clone and configure the project..."
echo
sudo chmod -R 777 /var/www/html
pushd /var/www/html 
git clone -b $BRNACHNAME $GITURL
sudo chmod -R 755 /var/www/html/
sudo chown -R $USER:$USER /var/www/html/$PROJECTNAME
cd /var/www/html/$PROJECTNAME
cd storage/ && mkdir -p framework/{sessions,views,cache} && chmod -R 775 framework && cd ..
composer install
sudo rm -r .env
echo
sleep 1
#set environment values
popd 
sudo chmod +x environment.sh
source environment.sh
echo
echo
sleep 1
#run the artisan commands
pushd /var/www/html/$PROJECTNAME
php artisan migrate
php artisan db:seed
php artisan optimize:clear
sudo chown -R www-data.www-data storage
sudo chown -R www-data.www-data bootstrap
echo
echo "clone and configuration completed..."
sleep 1

# Nginx Configurations
cd
cd AutoDep
sudo chmod +x nginx.sh
source nginx.sh
sudo nginx -test
sudo systemctl restart nginx

#other Operations
sudo apt-get update
# sudo rm -r automated_setup.sh nginx.sh environment.sh

echo "setup completed"
