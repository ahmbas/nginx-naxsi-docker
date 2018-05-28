#!/bin/bash
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
/usr/sbin/nginx -g 'daemon off; master_process on;'
