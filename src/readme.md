## @blumilksoftware/example-app
### About application
> placeholder

### Local development
```
cp .env.example .env
make init
make dev
```
Application will be running under [localhost:63851](localhost:63851) and [http://example-app.blumilk.localhost/](http://example-app.blumilk.localhost/) in Blumilk traefik environment. If you don't have a Blumilk traefik environment set up yet, follow the instructions from this [repository](https://github.com/blumilksoftware/environment).

#### Commands
Before running any of the commands below, you must run shell:
```
make shell
```

| Command                 | Task                                        |
|:------------------------|:--------------------------------------------|
| `composer <command>`    | Composer                                    |
| `composer test`         | Runs backend tests                          |
| `composer analyse`      | Runs Larastan analyse for backend files     |
| `composer cs`           | Lints backend files                         |
| `composer csf`          | Lints and fixes backend files               |
| `php artisan <command>` | Artisan commands                            |
| `npm run dev`           | Compiles and hot-reloads for development    |
| `npm run build`         | Compiles and minifies for production        |
| `npm run lint`          | Lints frontend files                        |
| `npm run lintf`         | Lints and fixes frontend files              |
| `npm run tsc`           | Runs TypeScript checker                     |


#### Containers

| service    | container name            | default host port               |
|:-----------|:--------------------------|:--------------------------------|
| `app`      | `example-app-app-dev`     | [63851](http://localhost:63851) |
| `database` | `example-app-db-dev`      | 63853                           |
| `redis`    | `example-app-redis-dev`   | 63852                           |
| `mailpit`  | `example-app-mailpit-dev` | 63854                           |
