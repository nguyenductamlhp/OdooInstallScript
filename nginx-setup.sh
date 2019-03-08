
sudo apt-get install nginx

sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/odoo
sudo ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo

sudo cat <<EOF > /etc/nginx/sites-available/odoo
upstream
    pllab {
        server 127.0.0.1:8069;
}
server  {
    server_name pllab;
    location / {
        proxy_pass http://pllab;
        proxy_set_header Host $host;
    }
}

EOF

sudo nginx -t
sudo /etc/init.d/nginx reload
