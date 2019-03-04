#!/bin/bash
################################################################################
# Script for installing Odoo V11 on Debian (could be used for other version too)
# Based on installation script by Yenthe Van Ginneken https://github.com/Yenthe666/InstallScript
# Author: William Olhasque
#-------------------------------------------------------------------------------
# This script will install Odoo on your Debian Jessie server. It can install multiple Odoo instances
# in one Ubuntu because of the different xmlrpc_ports
#-------------------------------------------------------------------------------
# Make a new file:
#  nano odoo-install.sh
# Place this content in it and then make the file executable:
#  chmod +x odoo-install.sh
# Execute the script to install Odoo:
# ./odoo-install
###############################################################################

########################## [] ###################################
# Install enviroment  for odoo 11
###############################################################################


##fixed parameters
#odoo
ODOO_USER="laravan"
PROJECT_NAME="laravan"
ODOO_HOME="opt/${ODOO_USER}-server"
LOG_FILE=$ODOO_HOME/${PROJECT_NAME}.log
#The default port where this Odoo instance will run under (provided you use the command -c in the terminal)
#Set to true if you want to install it, false if you don't need it or have it already installed.
INSTALL_WKHTMLTOPDF="True"
#Set the default Odoo port (you still have to use -c /etc/odoo-server.conf for example to use this.)
ODOO_PORT="8069"
#Choose the Odoo version which you want to install. For example: 10.0, 9.0, 8.0, 7.0 or saas-6. When using 'trunk' the master version will be installed.
#IMPORTANT! This script contains extra libraries that are specifically needed for Odoo 10.0
ODOO_VERSION="11.0"
#set the superadmin password
MASTER_PASSWORD="master_password"
OE_CONFIG="${ODOO_USER}-server"

#Python env
ODOO_PYTHON_ENV="${ODOO_HOME}/python_env"

###  WKHTMLTOPDF download links
## === Debian Jessie
## https://www.odoo.com/documentation/8.0/setup/install.html#deb ):
WKHTMLTOX_X64=https://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb


# Fix locale issue
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
export LC_ALL="en_US.UTF-8"

cat <<EOF > /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

EOF

echo -e "\n---- Create ODOO system user ----"
adduser --system --quiet --shell=/bin/bash --home=/opt/laravan-server --gecos 'ODOO' --group $ODOO_USER >> ./install_log
#The user should also be added to the sudo'ers group.
adduser $ODOO_USER sudo >> ./install_log

#
# Install dialog
#
echo -e "\n---- Update Server ----"
apt-get update >> ./install_log
echo -e "\n---- Install dialog ----"
apt-get install dialog -y >> ./install_log
#
# Remove Odoo and PostgreSQL
#
#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Upgrade Server ----"
apt-get upgrade -y >> ./install_log

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
#PostgreSQL Version
ODOO_POSTGRESQL_VERSION="10"

# Add official repository
cat <<EOF > /etc/apt/sources.list.d/pgdg.list
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main

EOF

echo -e "\n---- Install PostgreSQL Repo Key ----"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -


echo -e "\n---- Install PostgreSQL Server ${ODOO_POSTGRESQL_VERSION} ----"
apt-get update >> ./install_log
apt-get install postgresql-${ODOO_POSTGRESQL_VERSION} postgresql-server-dev-${ODOO_POSTGRESQL_VERSION}   -y >> ./install_log

echo -e "\n---- Creating the ODOO PostgreSQL User  ----"
su - postgres -c "createuser -s $ODOO_USER" 2> /dev/null || true

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
echo -e "\n---- Install packages ----"
apt-get install git python3.5 nano virtualenv xz-utils wget fontconfig libfreetype6 libx11-6 libxext6 libxrender1  node-less node-clean-css xfonts-75dpi gcc python3.5-dev libxml2-dev libxslt1-dev libevent-dev libsasl2-dev libssl-dev libldap2-dev  libpq-dev libpng-dev libjpeg-dev libjpeg-dev curl wget git python-pip gdebi-core python-dev libxml2-dev libxslt1-dev zlib1g-dev libldap2-dev libsasl2-dev node-clean-css node-less python-gevent -y >> ./install_log

#--------------------------------------------------
# Install Wkhtmltopdf if needed
#--------------------------------------------------
if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
    echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 10 ----"
    _url=$WKHTMLTOX_X64
    wget --quiet $_url
    gdebi --n `basename $_url` >> ./install_log
    rm `basename $_url`
else
    echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi

echo -e "\n---- Create Log and data directory ----"
touch $LOG_FILE
chown $ODOO_USER:$ODOO_USER $LOG_FILE
chown $ODOO_USER:$ODOO_USER $LOG_FILE

echo -e "\n---- Setting permissions on home folder ----"
chown -R $ODOO_USER:$ODOO_USER $ODOO_HOME/*

echo -e "\n==== Clone source code ===="
git clone https://nguyenductamlhp@github.com/nguyenductamlhp/laravan.git /opt/laravan-server/laravan >> ./install_log

#--------------------------------------------------
# Adding ODOO as a deamon (initscript)
#--------------------------------------------------
SERVICE_PATH=/etc/systemd/system/${PROJECT_NAME}.service
rm -rf $SERVICE_PATH

echo -e "* Create service file"
cat <<EOF > /etc/systemd/system/laravan.service
[Unit]
Description=Laravan server
After=network.target

[Service]
User=laravan
Group=laravan
ExecStart=python3 $ODOO_HOME/$PROJECT_NAME/odoo/odoo-bin --config=$ODOO_HOME/$PROJECT_NAME/config/server.conf

[Install]
WantedBy=multi-user.target

EOF

echo -e "* Reload daemon"
systemctl daemon-reload

echo -e "* Start ODOO on Startup"
systemctl enable /etc/systemd/system/laravan.service

echo -e "* Starting Odoo Service"
systemctl start /etc/systemd/system/laravan.service


echo "-----------------------------------------------------------"
echo "Done! The Odoo server is up and running. Specifications:"
echo "Port: $ODOO_PORT"
echo "User service: $ODOO_USER"
echo "User PostgreSQL: $ODOO_USER"
echo "Code location: $ODOO_USER"
echo "Start Odoo service:  systemctl start $SERVICE_PATH"
echo "Stop Odoo service:  systemctl stop $SERVICE_PATH"
echo "Restart Odoo service:  systemctl restart $SERVICE_PATH"
echo "-----------------------------------------------------------"
