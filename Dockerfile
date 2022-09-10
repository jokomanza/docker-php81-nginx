FROM trafex/php-nginx:latest

USER root

RUN apk add --no-cache \
    php81-apache2 \
    php81-bcmath \
    php81-bz2 \
    php81-calendar \
    php81-cgi \
    php81-common \
    php81-ctype \
    php81-curl \
    php81-dba \
    php81-dbg \
    php81-dev \
    php81-doc \
    php81-dom \
    php81-embed \
    php81-enchant \
    php81-exif \
    php81-ffi \
    php81-fileinfo \
    php81-fpm \
    php81-ftp \
    php81-gd \
    php81-gettext \
    php81-gmp \
    php81-iconv \
    php81-imap \
    php81-intl \
    php81-ldap \
    php81-litespeed \
    php81-mbstring \
    php81-mysqli \
    php81-mysqlnd \
    php81-odbc \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-pdo \
    php81-pdo_dblib \
    php81-pdo_mysql \
    php81-pdo_odbc \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pear \
    php81-pgsql \
    php81-phar \
    php81-phpdbg \
    php81-posix \
    php81-pspell \
    php81-session \
    php81-shmop \
    php81-simplexml \
    php81-snmp \
    php81-soap \
    php81-sockets \
    php81-sodium \
    php81-sqlite3 \
    php81-sysvmsg \
    php81-sysvsem \
    php81-sysvshm \
    php81-tidy \
    php81-tokenizer \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-xsl \
    php81-zip \
    libaio-dev libnsl g++ gcompat gcc musl-dev make \
    libc6-compat

RUN mkdir /opt/oracle

# Install Oracle Instantclient
RUN wget https://github.com/f00b4r/oracle-instantclient/raw/master/instantclient-basic-linux.x64-12.2.0.1.0.zip \
    && wget https://github.com/f00b4r/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.2.0.1.0.zip \
    && wget https://github.com/f00b4r/oracle-instantclient/raw/master/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip \
    && unzip instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
    && unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
    && unzip instantclient-sqlplus-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
    && rm -rf *.zip \
    && mv /opt/oracle/instantclient_12_2 /opt/oracle/instantclient

# create a symlink to Instant Client files.
RUN ln -s /opt/oracle/instantclient/libclntsh.so.12.1 /opt/oracle/instantclient/libclntsh.so \
    && ln -s /opt/oracle/instantclient/libocci.so.12.1 /opt/oracle/instantclient/libocci.so \
    && ln -s /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.1 \
    && ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 \
    && ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

RUN echo 'export LD_LIBRARY_PATH="/opt/oracle/instantclient"' >> /root/.bashrc
RUN echo 'umask 002' >> /root/.bashrc

RUn source /root/.bashrc

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/pecl81 /usr/bin/pecl

# Install oci
RUN pecl channel-update pecl.php.net
RUN echo 'instantclient,/opt/oracle/instantclient' | pecl install oci8
RUN echo "extension=oci8.so" > /etc/php81/conf.d/php-oci8.ini

USER nobody
