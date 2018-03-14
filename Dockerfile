FROM centos:7

MAINTAINER Rahul rui <rahulrui@ideaculture.com>

WORKDIR /app

ENV NGINX_VERSION 1.11.1

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN yum update -y && \
yum install -y gcc-c++ && \
yum install -y pcre pcre-devel && \
yum install -y openssl openssl-devel && \
yum install -y zlib zlib-devel && \
yum install -y wget

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O /tmp/nginx.tgz && \
tar xzf /tmp/nginx.tgz -C /tmp && \
mv /tmp/nginx-${NGINX_VERSION} /tmp/nginx && \
rm /tmp/nginx.tgz 

COPY nginx.conf /tmp/nginx/conf/

RUN cd /tmp/nginx && \
./configure --prefix=/app/nginx/ && \
make && \
make install && \
rm -rf /tmp/nginx

EXPOSE 80
EXPOSE 443

# Launch Nginx

ENTRYPOINT ["/app/nginx/sbin/nginx","-g","daemon off;","-c","/app/nginx/conf/nginx.conf"]
