###
##
## Monitorix
##
###

server {

        listen [::]:80;
        #listen [::]:443;
        listen 80;
        #listen 443;
        server_name ~^monitorix\..+\.dgo\.inktomis\.com$;
        root /var/lib/monitorix/www/;

        include allow_friends;
        deny all;

        access_log /var/log/nginx/monitorix.dgo.inktomis.com_access.log;
        error_log  /var/log/nginx/monitorix.dgo.inktomis.com_error.log;

        location / {
                try_files $uri $uri/ /index.html;
        }

        location /cgi/ {
                gzip off;
                root /var/lib/monitorix/www/;
                include /etc/nginx/fastcgi_params;
                fastcgi_pass unix:/var/run/fcgiwrap.socket;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
}

