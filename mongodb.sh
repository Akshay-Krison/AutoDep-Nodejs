#!/bin/bash
echo
for (( i=0; i !=1 ; ))
do
echo "MYSQL Installation Process Started...."
sudo apt-get update -y &> /dev/null
echo "Installing mysql..." 
sudo apt-get install mysql-server -y
RESULT=$?
if [ $RESULT = 0 ]; then
echo "Mysql Installed Successfully....."
sudo mysql -u root -p"$DATABASEPASS" -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DATABASEPASS'" &> /dev/null
sudo mysql -u root -p"$DATABASEPASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'" &> /dev/null
sudo mysql -u root -p"$DATABASEPASS" -e "create database $DATABASENAME" &> /dev/null
sudo mysql -u root -p"$DATABASEPASS" -e "FLUSH PRIVILEGES" &> /dev/null
i=1;
else
echo
echo "Mysql Installation Failed....."
sudo killall apt apt-get
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo dpkg --configure -a
sudo apt-get purge mysql-server -y
sudo apt-get purge mysql* -y
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo apt-get update -y
i=0;
fi
done
sudo service mysql restart 
echo "Mysql Installation Completed...."
