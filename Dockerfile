# As such, a valid Dockerfile must have FROM as its first instruction.
FROM python:3.7-stretch

# The MAINTAINER instruction allows you to set the Author field of the generated images.
MAINTAINER KUN <nguyentruongthanh.dn@gmail.com>


RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    nginx \
    curl \
    dirmngr \
    gnupg \
    vim \
    g++

RUN pip install uwsgi
RUN pip install django

# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
COPY uwsgi.ini /etc/uwsgi/

# Install Supervisord
RUN apt-get update && apt-get install -y supervisor

# Custom Supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY conf/nginx.conf /etc/nginx/sites-available/app.nginx.conf
# Which uWSGI .ini file should be used, to make it customizable
ENV UWSGI_INI /etc/uwsgi/uwsgi.ini

# By default, run 2 processes
ENV UWSGI_CHEAPER 2

# By default, when on demand, run up to 16 processes
ENV UWSGI_PROCESSES 16


EXPOSE 80 443

CMD ["/usr/bin/supervisord"]