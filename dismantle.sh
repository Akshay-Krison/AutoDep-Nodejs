#!/bin/bash
cd /var/www/html && ls
read -p "Enter the project folder name Listed above : " $FOLDERNAME
echo
echo "Starting Dismantle Your Project and its Dependecies..."
echo
sudo rm -R /var/www/html/$FOLDERNAME
echo
echo "Uninstalling Nginx...."
sudo apt-get --purge remove nginx-* -y
sudo rm -r /etc/nginx/
echo
sleep 10
echo
echo "Uninstalling Mysql Server...."
sudo apt remove --purge mysql-server -y
sudo apt purge mysql-server -y
sudo apt remove dbconfig-mysql -y
echo
sleep 10
echo
echo "Uninstall Composer and PHP..."
sudo apt-get purge composer* -y
sudo apt-get purge php7.* -y
echo
sleep 10
echo
echo "Cleaning and Update the Ubuntu Server..."
sudo apt-get autoclean -y
sudo apt-get autoremove -y
sudo apt-get update -y
echo
sleep 10
sudo dpkg --configure -a
sudo reboot
echo
echo "Dismantle Finished........"