FROM php:8.2-apache

WORKDIR /var/www/html/

# add php extensions 
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions intl mysqli imagick gd @composer

# install packages
RUN apt update && \
    apt install \
        vim \
        git -y

# apache
RUN a2enmod rewrite
RUN a2enmod ssl

# copy files
COPY src/ .
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# SSL
COPY config/grepmatch.dev.pem /etc/ssl/certs/grepmatch.dev.pem
COPY config/grepmatch.dev-key.pem /etc/ssl/private/grepmatch.dev-key.pem

# virtual Host
COPY config/000-default.conf /etc/apache2/sites-enabled/000-default.conf

ENTRYPOINT [ "/entrypoint.sh" ]
