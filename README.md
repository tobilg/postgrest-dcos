# postgrest-dcos
A Docker image for running https://github.com/begriffs/postgrest/ on DC/OS

## Configuration
The `postgrest` instance can be configured using environment variables:

* `POSTGRES_URL`: The hostname or ip address of the Postgres instance, concatenated by a `:` and the port on which the instance is running. Default is `postgresql.marathon.l4lb.thisdcos.directory:5432`. (**mandatory**)
* `POSTGRES_DATABASE`: The name of the database to use. (**mandatory**)
* `POSTGRES_SCHEMA`: The name of the schema to use. (**mandatory**)
* `POSTGRES_USER`: The name of the Postgres user. (**mandatory**)
* `POSTGRES_PASSWORD`: The Postgres user's password. (**mandatory**)
* `POSTGRES_TIMEOUT_SECONDS`: The timeout for which `dockerize` checks the availability of the PostGres service at the `POSTGRES_URL`. Default is `120 seconds.
* `POSTGREST_JWT_SECRET`: The JWT secret used to connect to `postgrest`. By default, a random 32 character string will be generated if nothing is provided. 
* `POSTGREST_DB_MAX_ROWS`: The number of rows that a query can return at maximum. Default is `1000`.
* `POSTGREST_DB_POOL_SIZE`: The number of connections which are used for connection pooling. Default is `5`.

## Running
You can run `postgrest` by using the following Marathon app definition:

```javascript
{
  "id": "postgrest",
  "cpus": 0.5,
  "mem": 1024.0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "tobilg/postgrest-dcos:0.1.0",
      "network": "HOST"
    }
  },
  "healthChecks": [
    {
      "protocol": "HTTP",
      "portIndex": 0,
      "path": "/",
      "gracePeriodSeconds": 5,
      "intervalSeconds": 20,
      "maxConsecutiveFailures": 3
    }
  ],
  "env": {
    "POSTGRES_USER": "myuser",
    "POSTGRES_PASSWORD": "mypassword",
    "POSTGRES_DATABASE": "mydatabase",
    "POSTGRES_SCHEMA": "myschema",
    "POSTGREST_JWT_SECRET": "mYseCR3t"
  },
  "portDefinitions": [
    {
      "port": 0,
      "protocol": "tcp",
      "name": "http",
      "labels": {
        "VIP_0": "postgrest:80"
      }
    }
  ],
  "requirePorts": false
}
```
