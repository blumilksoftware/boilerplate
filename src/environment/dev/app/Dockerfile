# For other versions check: https://hub.docker.com/_/composer/tags
FROM composer/composer:2.8.5-bin@sha256:f39305913df47b4de56c64f4719d35eedbd65d7d96ff554110b9e9bd0c7a18c0 AS composer-bin
FROM ghcr.io/php/pie:1.0.0-bin AS pie-bin
# For other versions check: https://hub.docker.com/_/node/tags?page=1&name=bullseye-slim
FROM node:22.13.1-bullseye-slim@sha256:78d58cb33cd6508d24dc07b6b9825d4669275b094ea2aafc9ae10610991d8945 AS node

# For other versions check: https://hub.docker.com/_/php/tags?page=1&name=fpm-bullseye
FROM php:8.4.3-fpm-bullseye@sha256:659e76cd9d0f03bbd4bad364c0d29ed736c5ea9035a1251b823a121ca4f6b1fd

COPY --from=composer-bin ./composer /usr/bin/composer

ARG USER_NAME=host-user
ARG USER_ID=1000
ARG PHP_FPM_GROUP=www-data

RUN adduser \
        --disabled-password \
        --uid ${USER_ID} \
        ${USER_NAME} \
    && usermod \
        --append \
        --groups \
        ${PHP_FPM_GROUP} \
        ${USER_NAME}

# Add node, npm, npx binaries
COPY --from=node --chown=${USER_NAME}:root /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node --chown=${USER_NAME}:root /usr/local/bin/node /usr/local/bin/node
RUN ln --symbolic /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && chown --no-dereference ${USER_NAME}:root /usr/local/bin/npm \
    && ln --symbolic /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && chown --no-dereference ${USER_NAME}:root /usr/local/bin/npx

# Use the default development configuration
RUN mv "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini"

# For other versions check: http://github.com/nginx/nginx/releases
# renovate: datasource=github-tags depName=nginx/nginx extractVersion=^release-(?<version>.*)$
ARG NGINX_VERSION="1.25.5"

# For other versions check: http://github.com/phpredis/phpredis/releases
# renovate: datasource=github-tags depName=phpredis/phpredis
ARG PHPREDIS_VERSION=6.2.0

RUN apt-get update \
    && apt-get install --assume-yes gpg \
    && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmour --output /etc/apt/trusted.gpg.d/apt.nginx.org.gpg > /dev/null \
    && echo "deb https://nginx.org/packages/mainline/debian bullseye nginx" | tee /etc/apt/sources.list.d/nginx.list \
    && apt-get update && apt-get install --assume-yes \
        nginx=${NGINX_VERSION}-1~bullseye \
        zip \
        libzip-dev \
        libpq-dev \
        supervisor \
        cron \
    && pie install \
        phpredis/phpredis:${PHPREDIS_VERSION} \
    && docker-php-ext-install \
        zip \
        pdo_pgsql

# For other versions check: http://github.com/xdebug/xdebug/releases
# renovate: datasource=github-tags depName=xdebug/xdebug
ARG XDEBUG_VERSION=3.4.5
ARG INSTALL_XDEBUG=true

RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pie install xdebug/xdebug:${XDEBUG_VERSION} \
;fi

COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /application

ENTRYPOINT ["/entrypoint.sh"]
