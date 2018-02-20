FROM php:7.1-fpm-alpine

MAINTAINER Thomas Appel <thomas.appel@tmt.de>

ENV EXT_DEPS \
  pkgconfig \
  libxml2-dev \
  libxslt \
  libxslt-dev \
  gnupg \
  dialog \
  zlib-dev \
  icu-dev \
  gettext-dev
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -xe; \
  apk update && apk add --no-cache $EXT_DEPS \
  && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
  && docker-php-ext-configure xsl \
  && docker-php-ext-install xsl \
  && docker-php-ext-enable xsl \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  && docker-php-ext-configure gettext \
  && docker-php-ext-install gettext \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip \
  && docker-php-ext-configure opcache \
  && docker-php-ext-install opcache \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && chmod +x /usr/local/bin/composer \
  # Cleanup build deps
  #  8 # clean up build deps
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*
