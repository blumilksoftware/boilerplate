## ExampleApp
### Local development
```
cp .env.example .env
make init
make shell
  # inside container
  npm run dev
```
Application will be running under [localhost:63851](localhost:63851) and [http://example-app.blumilk.localhost/](http://example-app.blumilk.localhost/) in Blumilk traefik environment. If you don't have a Blumilk traefik environment set up, follow the instructions in this [repository](https://github.com/blumilksoftware/environment).


### Commands
Before run every command from below list, you must run shell:
```
make shell
```
#### Command list
Composer:
```
composer <command>
```
Run backend tests:
```
composer test
```
Larastan analyse backend files:
```
composer analyse
```
Lints backend files:
```
composer cs
```
Lints and fixes backend files:
```
composer csf
```
Artisan commands:
```
php artisan <command>
```
Compiles and hot-reloads frontend for development:
```
npm run dev
```
Compiles and minifies for production:
```
npm run build
```
Lints frontend files:
```
npm run lint
```
Lints and fixes frontend files:
```
npm run lintf
```

### Containers

| service  | container name   | default host port               |
|:---------|------------------|---------------------------------|
| app      | example-app-app-dev     | [63851](http://localhost:63851) |
| database | example-app-db-dev      | 63853                           |
| redis    | example-app-redis-dev   | 63852                           |
| mailpit  | example-app-mailpit-dev | 63854                           |
