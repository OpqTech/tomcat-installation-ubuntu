#!/bin/bash

echo "\n################################################################"
echo "#                                                              #"
echo "#                       ***OpqTech***                          #"
echo "#                    Tomcat Installation                       #"
echo "#                                                              #"
echo "################################################################"

# Installing necessary packages
echo "\n\n*****Installing necessary packages"
sudo apt-get update -y 1>/dev/null
sudo apt-get install -y default-jre 1>/dev/null
echo "            -> Done"

# Downloading Apache Tomcat 9.0.68 version to OPT folder
echo "*****Downloading Apache Tomcat 9.0.68 version"
cd /opt
sudo systemctl stop tomcat 2>/dev/null
sudo rm -rf apache* tomcat*
sudo mkdir -p /opt/tomcat
sudo wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.tar.gz
sudo tar xf apache-tomcat-9.0.68.tar.gz -C /opt/tomcat 1>/dev/null
sudo rm -rf apache-tomcat-9.0.68.tar.gz
echo "            -> Done"

# Configuring Tomcat server for manager, host-manager and tomcat users
echo "*****Configuring Tomcat server for Manager, Host-manager and Credentials"
cd - 1>/dev/null
sudo cp context.xml /opt/tomcat/apache-tomcat-9.0.68/webapps/manager/META-INF/context.xml
sudo cp context.xml /opt/tomcat/apache-tomcat-9.0.68/webapps/host-manager/META-INF/context.xml
sudo cp tomcat-users.xml /opt/tomcat/apache-tomcat-9.0.68/conf/tomcat-users.xml
echo "            -> Done"

# Configuring Tomcat as a Service
echo "*****Configuring Tomcat as a Service"
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat 2>/dev/null
sudo chown -R tomcat: /opt/tomcat/*
sudo cp tomcat.service /etc/systemd/system/tomcat.service
sudo rm -rf tomcat-ubuntu
sudo systemctl daemon-reload 1>/dev/null
sudo systemctl start tomcat 1>/dev/null
echo "            -> Done"

# Check if tomcat is working
sudo systemctl is-active --quiet tomcat
echo "\n################################################################ \n"
if [ $? -eq 0 ]; then
	echo "Tomcat installed Successfully"
	echo "Access Tomcat using $(curl -s ifconfig.me):8080"
else
	echo "Tomcat installation failed"
fi
echo "\n################################################################ \n"
