```TAP info goes here```




```TAP Tanzu Postgres Operator Workaround```


##### This workaround only applies if you used the Tanzu Postgres Operator to prisvision your postgres instance(s)



````
kubectl exec -n postgres-databases -it pg-tap-0 -c pg-container -- bash -c “psql”


alter user postgres with superuser; and then \q

````


```update pg_hba.conf```


````
kubectl exec -n postgres-databases -it pg-tap-0 -c pg-container -- bash

    cd /pgsql/data
    echo “host all all all md5" >> pg_hba.conf
    echo “host all ‘pgadmin’ all md5” >> pg_hba.conf
    psql
    select pg_reload_conf();
    select pg_read_file(‘pg_hba.conf’);
    \q
    exit

````
