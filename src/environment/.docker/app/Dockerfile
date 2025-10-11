FROM registry.blumilk.pl/internal-public/secops-tools-bin:v1.1.0@sha256:80e61cf01f5465d6353bc4ad07e5940eb0055c572d265c7819e04f37167f8bc8 AS secops-tools-bin
FROM composer:2.8.12@sha256:e4580e48611e8f22e3440b1334557c9e8e893f753b05c67237fdddc0ece7d582 AS composer
FROM ghcr.io/php/pie:1.2.1-bin@sha256:8599d93b0e12de1deb775612d4311d3993cb95b1aeba841ff0b49bd1f1beb12d AS pie-bin
FROM node:24.9.0-bookworm-slim@sha256:3e69116c924bfcba6c6979aff60d966c37aef56d488ce091c69d442ebec9f103 AS node

FROM php:8.4.13-fpm-bookworm@sha256:c7fff1a9facdb4d4e05a9959e4f52d95c8880c70ac3f7592988a5b36ed5c71fc AS base

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=pie-bin /pie /usr/bin/pie

# For other versions check: https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/
# renovate: datasource=github-tags depName=nginx/nginx extractVersion=^release-(?<version>.*)$
ARG NGINX_VERSION="1.29.2"

RUN apt-get update \
    && apt-get install --assume-yes gpg \
    && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmour --output /etc/apt/trusted.gpg.d/apt.nginx.org.gpg > /dev/null \
    && echo "deb https://nginx.org/packages/mainline/debian bookworm nginx" | tee /etc/apt/sources.list.d/nginx.list \
    && apt-get update && apt-get install --assume-yes \
        nginx=${NGINX_VERSION}-1~bookworm \
        zip \
        libzip-dev \
        supervisor \
        libpq-dev \
    && docker-php-ext-install \
        pdo_pgsql 

COPY ./environment/.docker/app/entrypoint.sh /entrypoint.sh
COPY ./environment/.docker/app/nginx.conf /etc/nginx/nginx.conf

WORKDIR /application

ENTRYPOINT ["/entrypoint.sh"]

FROM base AS local

COPY --from=secops-tools-bin /usr/local/bin/age /usr/local/bin/age-keygen /usr/local/bin/sops /usr/local/bin/

RUN mv "${PHP_INI_DIR}/php.ini-development" "${PHP_INI_DIR}/php.ini"

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

# renovate: datasource=github-tags depName=xdebug/xdebug
ARG XDEBUG_VERSION=3.4.6
ARG INSTALL_XDEBUG=false

RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pie install xdebug/xdebug:${XDEBUG_VERSION} \
;fi

FROM composer AS vendor-build

WORKDIR /app_composer_dependencies

COPY composer.json composer.lock ./

RUN composer install \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --no-dev \
        --prefer-dist \
        --ignore-platform-reqs

FROM node AS frontend-build

WORKDIR /app_frontend_dependencies

ARG ENVIRONMENT_ARG
ENV ENVIRONMENT=${ENVIRONMENT_ARG}

# last position is target directory
COPY package.json \
    package-lock.json \
    postcss.config.js \
    vite.config.js \
    ./

COPY ./environment/${ENVIRONMENT}/app/vite.${ENVIRONMENT}.env .env

RUN npm clean-install

COPY resources/js ./resources/js/
COPY resources/css ./resources/css/
COPY resources/views ./resources/views/

RUN npm run build

FROM base AS production

ARG ENVIRONMENT_ARG
ENV ENVIRONMENT=${ENVIRONMENT_ARG}

RUN docker-php-ext-install \
    opcache

RUN mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

COPY ./environment/${ENVIRONMENT}/app/php.ini ${PHP_INI_DIR}/conf.d/zzz-overrides-php.ini
COPY ./environment/${ENVIRONMENT}/app/php-fpm.conf /usr/local/etc/php-fpm.d/zzz-overrides.conf
COPY ./environment/${ENVIRONMENT}/app/supervisord.conf /etc/supervisor/custom-supervisord.conf

# Copy Frontend build
COPY --chown=www-data:www-data --from=frontend-build /app_frontend_dependencies/public/build ./public/build/

# Copy Composer dependencies
COPY --chown=www-data:www-data --from=vendor-build /app_composer_dependencies/vendor ./vendor/

# Copy App files
COPY --chown=www-data:www-data . .

# Remove unnecessary files
RUN rm --recursive --force \
    postcss.config.js \
    vite.config.js \
    .dockerignore \
    environment/.docker \
    environment/dev

RUN composer dump-autoload --optimize

EXPOSE 80

ARG PROJECT_BUILD_VERSION_ARG
ENV PROJECT_BUILD_VERSION=${PROJECT_BUILD_VERSION_ARG}
