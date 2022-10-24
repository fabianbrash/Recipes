#### Postgres info goes here


```Connecting to an instance```


````

psql postgresql://<username>:<password>@<hostname>:<port>/<database>

psql postgresql://pgadmin:my-password@pg-mypostgres.postgres-databases.svc.cluster.local:5432/pg-mypostgres

````

[https://www.prisma.io/dataguide/postgresql/connecting-to-postgresql-databases](https://www.prisma.io/dataguide/postgresql/connecting-to-postgresql-databases)


```Commands```


[https://www.prisma.io/dataguide/postgresql/create-and-delete-databases-and-tables](https://www.prisma.io/dataguide/postgresql/create-and-delete-databases-and-tables)


````
\?

\du

\l

\q

SELECT datname FROM pg_database;


CREATE DATABASE school ENCODING 'UTF8';

````



