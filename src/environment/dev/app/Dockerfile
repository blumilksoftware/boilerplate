# For other versions check: https://hub.docker.com/_/composer/tags
FROM composer/composer:2.8.10-bin@sha256:b85784e99453d3b64099ca094298666a476e83a70e8bcd0f252675d2fdc4e4e0 AS composer-bin
FROM ghcr.io/php/pie:1.0.0-bin@sha256:f8fb97db83aa125841c0429bd4ea1fc8c34eecf30873e00e1b5b729678b6538d AS pie-bin
# For other versions check: https://hub.docker.com/_/node/tags?page=1&name=bookworm-slim
FROM node:24.4.0-bookworm-slim@sha256:1b044a60874f1b57ac8c4e708ddb3a00e55b34586ebbacce09a48796dafcc799 AS node

# For other versions check: https://hub.docker.com/_/php/tags?page=1&name=fpm-bookworm
FROM php:8.4.10-fpm-bookworm@sha256:c9d4beea5abc16ba2c5a52aa0caafd534500682bbec17411fad9198bb47ec196

COPY --from=composer-bin ./composer /usr/bin/composer
COPY --from=pie-bin /pie /usr/bin/pie

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

# For other versions check: http://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/
# renovate: datasource=github-tags depName=nginx/nginx extractVersion=^release-(?<version>.*)$
ARG NGINX_VERSION="1.29.0"

# For other versions check: http://github.com/phpredis/phpredis/releases
# renovate: datasource=github-tags depName=phpredis/phpredis
ARG PHPREDIS_VERSION=6.2.0

RUN apt-get update \
    && apt-get install --assume-yes gpg \
    && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmour --output /etc/apt/trusted.gpg.d/apt.nginx.org.gpg > /dev/null \
    && echo "deb https://nginx.org/packages/mainline/debian bookworm nginx" | tee /etc/apt/sources.list.d/nginx.list \
    && apt-get update && apt-get install --assume-yes \
        nginx=${NGINX_VERSION}-1~bookworm \
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
