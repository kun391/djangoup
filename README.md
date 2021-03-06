# https://github.com/kun391/djangoup

## Maintained by: [KUN](https://github.com/kun391/djangoup)

This is the Git repo of the DOCKER DJANGO IMAGE.


# Tutorial

Follow these steps to deploy a simple  _Hello, world!_ app into production:

## Dockerfile

This is the step I hope to be able to eliminate eventually. 

```
vim Dockerfile
```

Copy and save the following:

```
# Dockerfile
FROM kun391/djangoup:panmy

MAINTAINER Some Guy 

....


WORKDIR /your-application-dir

....

```

## Start Django with docker-compose.yml

Step 1
```
vim docker-compose.yml
```
Copy and save the following:

```
version: '3'
services:
  # container for API
  app:
    image: kun391:djangoup:panmy
    ports:
      - 8000:80
    depends_on:
      - db
    volumes:
      - .:/usr/src/app
      - ./conf/nginx.conf:/etc/nginx/sites-available/default
      #- ./passenger_wsgi.py:/usr/src/app/demo/passenger_wsgi.py
   #working_dir: /usr/src/app/demo
    command:
    - /bin/bash
    - -c
    - |
      service nginx restart
      tail -f /dev/null 2>&1
    restart: on-failure
  db:
    image: mysql:5.7
    ports:
      - 3305:3306
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: db
      MYSQL_USER: dbuser
      MYSQL_PASSWORD: user123
  ...

```

Assuming all steps were followed correctly, this will pull all the required images and start serving the app:
```
docker-compose up -d
```

Step 2
Create the project directory on the server:

```
docker-compose exec app django-admin startproject demo

docker-compose stop
```

Step 3
Copy and save the following - config/nginx.conf:

```
# config/nginx.conf

server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /usr/src/app/demo;
    passenger_enabled on;

    error_log /var/log/nginx/error.log;

    passenger_python /usr/bin/python3;
    passenger_app_root /usr/src/app/demo; 
    passenger_group www-data;
    
    passenger_friendly_error_pages on;
    passenger_app_type wsgi;
    passenger_startup_file passenger_wsgi.py;

    #tell passenger, where the /static located
    
    location / {
        root /usr/src/app/demo;
        passenger_enabled on;
    }

    location /static {
        alias /usr/src/app/demo/static;
        passenger_document_root /usr/src/app/demo/static;
    }

    #tell passenger, where the /media located
    location /media {
        alias /usr/src/app/demo/media;
        passenger_document_root /usr/src/app/demo/media;
    }
    
    location ~* .(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 365d;
    }
}


```
*We can customize the config if we need*

Step 4

We need edit Setting.py and add to end of file:

```
#Setting.py

...

...

STATIC_ROOT = os.path.join(BASE_DIR, 'static')
```

Uncomment this line in docker-compose.yaml
```
#- ./passenger_wsgi.py:/usr/src/app/demo/passenger_wsgi.py

#working_dir: /usr/src/app/demo
```

Step 5

We access following and finish:

```
docker-compose up -d

docker-compose exec app python3 manage.py migrate

docker-compose exec app python3 manage.py collectstatic
```

NOW, We can access this with localhost:8000 for FE and Admin is localhost:8000/admin

# Contributing


# License
MIT