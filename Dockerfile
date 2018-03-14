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
tar xzf /tmp/nginx.tgz -C /app && \
mv /app/nginx-${NGINX_VERSION} /app/nginx && \
rm /tmp/nginx.tgz 

COPY nginx.conf /app/nginx/conf/

RUN cd /app/nginx && \
./configure && \
make && \
make install

EXPOSE 80
EXPOSE 443

# Launch Nginx

ENTRYPOINT ["/usr/local/nginx/sbin/nginx","-g","daemon off;","-c","/app/nginx/conf/nginx.conf"]
