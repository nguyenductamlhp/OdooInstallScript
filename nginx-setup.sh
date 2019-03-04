
sudo apt-get install nginx

sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/odoo
sudo ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo

sudo cat <<EOF > /etc/nginx/sites-available/odoo
upstream
    nhadinh.com {
        server 127.0.0.1:8069;
}
server  {
    server_name nhadinh.com;
    location / {
        proxy_pass http://nhadinh.com;
    }
}

EOF

sudo nginx -t
sudo /etc/init.d/nginx reload
