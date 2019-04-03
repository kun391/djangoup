# As such, a valid Dockerfile must have FROM as its first instruction.
FROM python:3.6

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        python3-pip \
        vim

RUN pip3 install django

# The MAINTAINER instruction allows you to set the Author field of the generated images.
MAINTAINER KUN <nguyentruongthanh.dn@gmail.com>

# The main purpose of a CMD is to provide defaults for an executing container.
EXPOSE 8000