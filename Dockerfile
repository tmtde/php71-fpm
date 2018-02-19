FROM php:7.1-fpm-alpine

MAINTAINER Thomas Appel <thomas.appel@tmt.de>

ARG "BUILD_DATE=unknown"
ARG "BUILD_VERSION=unknown"
ARG "VCS_URL=unknown"
ARG "VCS_REF=unknown"
ARG "VCS_BRANCH=unknown"

# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL org.label-schema.name="PHP 7.1 FPM" \
    org.label-schema.description="Alpine Linux container with PHP 7.1, extenstions and composer" \
    org.label-schema.vendor="TMT GmbH & Co. KG" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.version=$BUILD_VERSION \
    org.label-schema.vcs-url=$VCS_URL \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-branch=$VCS_BRANCH

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
  && docker-php-ext-install opcache

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Cleanup build deps
#  8 # clean up build deps
RUN apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*
