FROM centos:7

ADD http://nginx.org/download/nginx-1.14.0.tar.gz /tmp/nginx-source/
ADD https://github.com/nbs-system/naxsi/archive/master.tar.gz /tmp/naxsi-source/
RUN cd /tmp/nginx-source/ && tar -zxvf nginx-1.14.0.tar.gz
RUN cd /tmp/naxsi-source/ && tar -zxvf master.tar.gz

RUN mkdir -p /var/lib/nginx/body
RUN yum install -y pcre openssl gzip zlib gcc pcre-devel openssl-devel
RUN ls /tmp/nginx-source
RUN cd /tmp/nginx-source/nginx-1.14.0 &&  ./configure --conf-path=/etc/nginx/nginx.conf --add-module=../../naxsi-source/naxsi-master/naxsi_src/ \
 --error-log-path=/var/log/nginx/error.log --http-client-body-temp-path=/var/lib/nginx/body \
 --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-log-path=/var/log/nginx/access.log \
 --http-proxy-temp-path=/var/lib/nginx/proxy --lock-path=/var/lock/nginx.lock \
 --pid-path=/var/run/nginx.pid --with-http_ssl_module \
 --without-mail_pop3_module --without-mail_smtp_module \
 --without-mail_imap_module --without-http_uwsgi_module \
 --without-http_scgi_module --with-ipv6 --prefix=/usr

RUN cd /tmp/nginx-source/nginx-1.14.0 && make

RUN cd /tmp/nginx-source/nginx-1.14.0 && make install

RUN cp /tmp/naxsi-source/naxsi-master/naxsi_config/naxsi_core.rules /etc/nginx/ -fv

COPY nginx.conf.template /etc/nginx

COPY naxsi.rules /etc/nginx

RUN mkdir -p /opt/nginx
COPY start_nginx.sh /opt/nginx
RUN chmod a+x /opt/nginx/start_nginx.sh

RUN /usr/sbin/nginx -t && yum install -y gettext

EXPOSE 80

CMD ["bash", "/opt/nginx/start_nginx.sh"]
