# Dockerfile for building Nginx from source with PageSpeed, Brotli, and ChaCha cipher modules

###### Dockerfile for dockerization of Nginx on Alpine Linux. #######
#                                                                   #
#####################################################################
#       DOCKERISED NGINX SERVICE BUILT ON TOP OF ALPINE LINUX       #
#-------------------------------------------------------------------#
#                   Built and maintained by                         #
#                       Harsha Vardhan J                            #
#               https://github.com/HarshaVardhanJ                   #
#####################################################################
#                                                                   #
# This Dockerfile does the following:                               #
#                                                                   #
#    1. Imports the latest base image of Alpine Linux.              #
#    2. Updates the repositories via the package manager.           #
#    3. Installs packages needed for building Nginx with            #
#       Brotli and ModSecurity support from source.                 #
#    5. Downloads Nginx, OpenSSL, Brotli, ModSecurity files         #
#       for compilation.                                            #
#    6. Complies Nginx with OpenSSL, Brotli, and ModSecurity        #
#       modules.                                                    #
#    7. Copies 'nginx.conf' configuration file to container         #
#       to be run.                                                  #
#    8. Copies the modsecurity.conf configuration file to           #
#       container to be run.                                        #
#    9. Exposes port 80 and 443 on the container.                   #
#    10. Starts Nginx.                                              #
#                                                                   #
# Note : Do not forget to expose ports on your machine if you       #
#        wish to access the Nginx web server.                       #
#                                                                   #
#####################################################################

# Using a base image of Alpine Linux
FROM alpine:latest

# Environment variables to store version numbers
ENV NGINX_VERSION 1.14.2
ENV OPENSSL_VERSION 1.1.1a

# Arguments to be added while configuring Nginx
RUN CONFIG="\
		--prefix=/etc/nginx \
		--sbin-path=/usr/sbin/nginx \
		--modules-path=/usr/lib/nginx/modules \
		--conf-path=/etc/nginx/nginx.conf \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
		--user=nginx \
		--group=nginx \
		--with-openssl=../openssl \
		--with-http_ssl_module \
		--with-http_realip_module \
		--with-http_addition_module \
		--with-http_sub_module \
		--with-http_dav_module \
		--with-http_flv_module \
		--with-http_mp4_module \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_random_index_module \
		--with-http_secure_link_module \
		--with-http_stub_status_module \
		--with-http_auth_request_module \
		--with-http_xslt_module=dynamic \
		--with-http_image_filter_module=dynamic \
		--with-http_geoip_module=dynamic \
		--with-threads \
		--with-stream \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
		--with-stream_geoip_module=dynamic \
		--with-http_slice_module \
		--with-mail \
		--with-mail_ssl_module \
		--with-compat \
		--with-file-aio \
		--with-http_v2_module \
		--add-module=../ngx_brotli \
		--add-dynamic-module=../ModSecurity-nginx \
	" \
	####################### Add user and group 'nginx'
	#
	&& addgroup -S nginx \
	&& adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
	####################### Install Packages necessary for building Nginx from source
	# 
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		pcre-dev \
		zlib-dev \
		linux-headers \
		gnupg1 \
		libxslt-dev \
		gd-dev \
		geoip-dev \
		perl-dev \
	&& apk add --no-cache --virtual .modsec-deps \
		libxml2-dev \
		flex \
		bison \
		yajl-dev
	&& apk add --no-cache --virtual .brotli-deps \
		autoconf \
		libtool \
		automake \
		git \
		g++ \
		cmake \
	&& apk add --no-cache \
		doxygen \
		geoip \
		geoip-dev \
		yajl \
		libstdc++ \
		git \
		sed \
		libmaxminddb-dev \
	&& mkdir -p /usr/src \
	&& cd /usr/src \
	####################### Download and extract Nginx
	#
	&& wget -qc http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -O nginx.tar.gz \
	&& tar -zxC /usr/src -f nginx.tar.gz \
	&& mv /usr/src/nginx-$NGINX_VERSION /usr/src/nginx \
	####################### Download and extract OpenSSL
	#
	&& wget -qc https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz -O openssl.tar.gz \
	&& tar -zxC /usr/src -f openssl.tar.gz \
	&& mv /usr/src/openssl-$OPENSSL_VERSION /usr/src/openssl \
	####################### Download and extract Nginx-Brotli
	#
	&& git clone --recursive https://github.com/eustas/ngx_brotli.git \
	&& cd ngx_brotli \
	&& git submodule update --init \
	####################### Add ModSecurity module
	#
	&& cd /usr/src \
	&& git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity \
	&& cd ModSecurity \
	&& git submodule init \
	&& git submodule update \
	&& ./build.sh \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /usr/src \
	&& git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git \
	&& mkdir -p /etc/nginx/modsec \
	&& wget -qc -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended \
	&& mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf \
	&& sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf \
	# Compile Nginx
	#
	&& cd /usr/src/nginx \
	&& ./configure $CONFIG --with-debug \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& mv objs/nginx objs/nginx-debug \
	&& mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so \
	&& mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so \
	&& mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so \
	&& mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so \
	&& ./configure $CONFIG --with-compat \
	&& make modules \
	&& mv objs/ngx_http_modsecurity_module.so /etc/nginx/modules \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& rm -rf /etc/nginx/html/ \
	&& mkdir /etc/nginx/conf.d/ \
	&& mkdir -p /usr/share/nginx/html/ \
	&& install -m644 html/index.html /usr/share/nginx/html/ \
	&& install -m644 html/50x.html /usr/share/nginx/html/ \
	&& install -m755 objs/nginx-debug /usr/sbin/nginx-debug \
	&& install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so \
	&& install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so \
	&& install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so \
	&& install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so \
	&& install -m755 objs/ngx_http_modsecurity_module.so /usr/lib/nginx/modules/ngx_http_modsecurity_module.so ; \
	ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
	&& strip /usr/sbin/nginx* \
	&& strip /usr/lib/nginx/modules/*.so \
	&& cd /usr/src \
	&& rm -rf /usr/src/* \
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& apk del .build-deps \
	&& apk del .brotli-deps \
	&& apk del .modsec-deps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/ \
	\
	# Bring in tzdata so users could set the timezones through the environment
	# variables
	&& apk add --no-cache tzdata \
	\
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Run as user nginx
USER nginx

# Expose ports 80 and 443
EXPOSE 80 443

# System call signal that will be sent to the container to exit
STOPSIGNAL SIGTERM

# Running nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

# Maintainer information
LABEL maintainer="Harsha Vardhan J" \
      github.account="https://github.com/HarshaVardhanJ" \
      dockerfile.github.page="https://github.com/HarshaVardhanJ/docker_files\
/blob/master/nginx/nginx-brotli-modsecurity-alpine/Dockerfile" \
      description="This Dockerfile creates an Nginx webserver listening on port 80 \
      and 443. Nginx has been compiled with support for Brotli compressions and \
      ModSecurity." \
      version="0.1"
