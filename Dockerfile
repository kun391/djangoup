# As such, a valid Dockerfile must have FROM as its first instruction.
FROM ubuntu:18.04

# The MAINTAINER instruction allows you to set the Author field of the generated images.
MAINTAINER KUN <nguyentruongthanh.dn@gmail.com>

USER root

ARG MYSQL=yes

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get install -y --no-install-recommends \ 
    apt-utils \
    nginx \
    python3-dev \
    python3-pip \
    curl \
    dirmngr \
    gnupg \
    g++

RUN apt-get update && apt-get install -y libmysqlclient-dev && pip3 install setuptools && pip3 install -U wheel && pip3 install mysqlclient

RUN pip3 install django

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y --no-install-recommends apt-transport-https ca-certificates

RUN touch /etc/apt/sources.list.d/passenger.list
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'

RUN apt-get update 

#Install Passenger + Nginx module
RUN apt-get install -y --no-install-recommends libnginx-mod-http-passenger

RUN if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

RUN ls /etc/nginx/conf.d/mod-http-passenger.conf

RUN curl https://raw.githubusercontent.com/kennethreitz/pipenv/master/get-pipenv.py | python3
RUN export LC_ALL=C.UTF-8

RUN /usr/bin/passenger-config validate-install
RUN /usr/sbin/passenger-memory-stats

EXPOSE 80 443

CMD ["nginx", "start"]