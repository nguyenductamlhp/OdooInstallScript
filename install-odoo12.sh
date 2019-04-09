#!/bin/bash
##############################################################################
# Make a new file:
# vi install.sh
# Place this content in it and then make the file executable:
#  chmod +x install.sh
# Execute the script to install Odoo:
# ./install.sh
##############################################################################

########################## [Directory tree] ##################################
#/home/plmedia
#|--------plmedia-production
#|---------------------|----plmedia (soure code)
#|---------------------|----data (filestore, sesssion, ...)
#|---------------------|----plmedia.log (log file)

##############################################################################


##fixed parameters
#odoo
ODOO_USER="plmedia"
PROJECT_NAME="plmedia"
ODOO_VERSION="11.0"

# ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~

echo -e "================ [UPDATE SERVER] ================"
apt-get update
apt-get upgrade -y
apt-get install dialog -y
apt install htop -y


echo -e "================ [Fix locale issues] ================"
locale-gen "en_US.UTF-8"
dpkg-reconfigure locales
export LC_ALL="en_US.UTF-8"

cat <<EOF > /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

EOF


echo -e "================ [Add user & change password] ================"
useradd -m -g sudo -s /bin/bash plmedia
passwd plmedia


echo -e "================ [Install libs] ================"
apt-get install -y autoconf build-essential fontconfig gcc git idle-python3.5 libevent-dev libfreetype6 libgle3 libjpeg-dev libldap2-dev libpng-dev libpng12-dev libpq-dev libqt4-dbus libqt4-network libqt4-script libqt4-test libqt4-xml libqtcore4 libqtgui4 libsasl2-dev libssl-dev libtool libx11-6 libxext6 libxml2-dev libxrender1 libxslt1-dev nano node-clean-css node-less pkg-config poppler-utils python-dev python-imaging python-opengl python-pip python-pyrex python-pyside.qtopengl python-qt4 python-qt4-gl python-setuptools python3-pip python3.5 python3.5-dev qt4-designer qt4-dev-tools virtualenv wget xfonts-75dpi xz-utils libsassa
sudo npm install -g rtlcss -y


echo -e "================ [Set git alias] ================"
su - plmedia -c "git config --global alias.co checkout"
su - plmedia -c "git config --global alias.br branch"
su - plmedia -c "git config --global alias.ci commit"
su - plmedia -c "git config --global alias.st status"


echo -e "================ [Install WKHTMLTOPDF] ================"
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
mv wkhtmltox/bin/wkhtmlto* /usr/bin/
ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf


echo -e "================ [Install postgresql] ================"
cat <<EOF > /etc/apt/sources.list.d/pgdg.list
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main

EOF

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update -y
apt-get install postgresql-10 postgresql-server-dev-10 -y

su - postgres -c "createuser -s plmedia" 2> /dev/null || true

pip install pgcli -y
apt-get install pg-activity -y


echo -e "================ [Create instance's folder] ================"
su - plmedia -c "mkdir /home/plmedia/plmedia-production"
su - plmedia -c "mkdir /home/plmedia/plmedia-production/data"
su - plmedia -c "touch /home/plmedia/plmedia-production/plmedia.log"
sudo chown -R plmedia /home/plmedia/plmedia-production/


echo -e "================ [Clone source code] ================"
git clone https://nguyenductamlhp@github.com/nguyenductamlhp/plmedia.git -b 12.0.1 /home/plmedia/plmedia-production/plmedia


echo -e "================ [Install requirements.txt] ================"
sudo -H pip install -r /home/plmedia/plmedia-production/plmedia/odoo/requirements.txt


echo -e "================ [Create service] ================"
cat <<EOF > /etc/systemd/system/plmedia.service
[Unit]
Description=plmedia server
After=postgresql.service

[Service]
Type=simple
User=plmedia
ExecStart=/home/plmedia/plmedia-production/plmedia/odoo/odoo-bin --config=/home/plmedia/plmedia-production/plmedia/config/server.conf

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable plmedia.service
systemctl start plmedia
