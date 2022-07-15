## boilerplate
A boilerplate for PHP projects with plug-and-play dockerized environment, Composer and its scripts, preconfigured Github Actions, added [Codestyle package](https://github.com/blumilksoftware/codestyle) and handy scripts, including starting a Laravel project.

## Local setup

- clone the repository
- initialize `.env` file and customize if needed

      cp .env.example .env

- build containers

      docker-compose build --no-cache --pull

- run containers

      docker-compose up -d

## Available containers (local)

- **php** - php and composer stuff
- **node** - npm stuff
- **mysql** - database for local development
- **redis**
- **mailhog** - for emails preview

## xDebug

To use xDebug you need to set `DOCKER_INSTALL_XDEBUG` to `true` in `.env` file.\
Then rebuild php container `docker-compose up --build -d php`.\
You can also set up xDebug params (see docs https://xdebug.org/docs/all_settings) in `docker/dev/php/php.ini` file:

Default values for xDebug:

```
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.log_level=0
```

### Disable xDebug

it is possible to disable the Xdebug completely by setting the option **xdebug.mode** to **off**, or by setting the
environment variable **XDEBUG_MODE=off**\
See docs (https://xdebug.org/docs/all_settings#mode)

CLI:

```
XDEBUG_MODE=off php artisan test
```
