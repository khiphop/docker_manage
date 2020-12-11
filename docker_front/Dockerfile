FROM php:7.2-fpm

#设置时区
ENV TZ "Asia/Shanghai"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
&& apt-get clean

RUN set -x && apt-get update

RUN apt-get install -y \
    nginx \
	cron \
	zlib1g-dev \
	libmcrypt-dev \
	procps \
	vim

RUN apt-get purge -y --auto-remove

RUN apt-get install -y libwebp-dev libjpeg-dev libpng-dev libfreetype6-dev \
    && docker-php-source extract \
    && cd /usr/src/php/ext/gd \
    && docker-php-ext-configure gd --with-webp-dir=/usr/include/webp --with-jpeg-dir=/usr/include --with-png-dir=/usr/include --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install gd

RUN pecl install redis-3.1.2 \
    && docker-php-ext-enable redis

# zip扩展是excel下载需要
RUN docker-php-ext-install pcntl pdo_mysql opcache
RUN docker-php-ext-install shmop sysvmsg sysvsem sysvshm

RUN curl -fsSL 'https://picmini.fhabc.com/server_file/php/libzip-1.3.0.tar.gz' -o libzip-1.3.0.tar.gz \
    && tar -zxvf libzip-1.3.0.tar.gz \
    && ( \
        cd libzip-1.3.0 \
        && ./configure \
        && make \
        && make install \
    )

RUN docker-php-ext-install zip
RUN (crontab -l; echo "0 6 * * * find /www/api/game/runtime -mtime +3 -name \"*.log\" -exec rm -rf {} \;" ) | crontab

ADD php/php.ini /usr/local/etc/php/
ADD php/php-fpm.conf /usr/local/etc/
ADD php/www.conf /usr/local/etc/php-fpm.d/
ADD php/zz-docker.conf /usr/local/etc/php-fpm.d/
ADD nginx/nginx.conf /etc/nginx/
ADD nginx/conf.d /etc/nginx/conf.d
RUN mkdir /etc/nginx/ssl
ADD nginx/ssl /etc/nginx/ssl

CMD php-fpm -D && nginx -g "daemon off;"  && /etc/init.d/cron start
