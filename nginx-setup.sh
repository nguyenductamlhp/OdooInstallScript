
sudo apt-get install nginx

sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/odoo
sudo ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo

sudo cat <<EOF > /etc/nginx/sites-available/odoo
upstream
    pllab {
        server 127.0.0.1:8069;
    }
server {
    listen 80 default_server;
    server_name pllab;
    proxy_buffers 16 64k;
    proxy_buffer_size 128k;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    #proxy_redirect http:// https://;
    proxy_read_timeout 600s;
    client_max_body_size 100m;

    location / {
        proxy_pass http://pllab;
    }

    location /longpolling {
        proxy_pass http://127.0.0.1:8072;
    }
}


EOF

sudo nginx -t
sudo /etc/init.d/nginx reload
