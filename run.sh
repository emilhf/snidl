#!/usr/bin/env sh
pkill nginx
/usr/local/openresty/nginx/sbin/nginx  -p /opt/openresty-quickstart -c conf/nginx.conf
