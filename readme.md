# Blumilk Boilerplate
A boilerplate for PHP projects with plug-and-play dockerized environment, Inertia.js, Composer and its scripts, preconfigured Github Actions, added [Codestyle package](https://github.com/blumilksoftware/codestyle), [Eslint package](https://github.com/blumilksoftware/eslint-config-blumilk)  and handy scripts, including starting a Laravel project.

## Prerequisites
- Bash shell
- Git installed

## Usage
To use the script, you can either pass arguments directly or enter them interactively when prompted.

### Direct argument passing
```bash
bash <(curl -s https://raw.githubusercontent.com/blumilksoftware/boilerplate/main/init.sh) <app-name> [app-namespace] [branch-name] [app-host-port] [db-host-port] [mailpit-dashboard-port] [redis-host-port]
```

- `<app-name>`: Required. Name of your application.
- `[app-namespace]`: Optional. The namespace for your application. Defaults to `App` if not provided.
- `[branch-name]`: Optional. The specific branch to clone. Defaults to the `main` branch if not provided.
- `[app-host-port]`: Optional. Docker app host port. Defaults to 63851.
- `[db-host-port]`: Optional. Docker database host port. Defaults to 63853.
- `[mailpit-dashboard-port]`: Optional. Docker Mailpit dashboard host port. Defaults to 63854.
- `[redis-host-port]`: Optional. Docker Redis host port. Defaults to 63852.

### Interactive Mode
Run the script without arguments:
```bash
bash <(curl -s https://raw.githubusercontent.com/blumilksoftware/boilerplate/main/init.sh)
```
You will be prompted to enter the application name, namespace, branch name, and Docker port settings.
