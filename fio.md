

```FIO examples```



```Install```


````
sudo apt install -y fio  ## Ubuntu, Debian
````

### Mixed Random Workload 3 reads for 1 write closely mimicking a DB

````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

````

### Random Reads

````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=randread
````

### Random Writes
````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=randwrite
````


### Sequential Reads

````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=read
````

### Sequential Writes

````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=4G --readwrite=write
````

### Random Workload to a different Windows Volume

````
fio --randrepeat=1 --direct=1 --gtod_reduce=1 --name=test --filename=F\:\test --bs=4k --iodepth=64 --size=1G --readwrite=randrw --rwmixread=75
````

### comprehensive test

````
mkdir -p fio-test && cd fio-test
fio --name=fsync --rw=write --ioengine=sync --fdatasync=1 \
    --size=200m --bs=2300 --runtime=30 --time_based | grep -E "IOPS=|sync \(|99.00th|99.50th"
cd .. && rm -rf fio-test
````

### comprehensive test 2

````
mkdir -p fio-test && cd fio-test

echo "=== fsync latency (etcd/MySQL pattern) ==="
fio --name=fsync --rw=write --ioengine=sync --fdatasync=1 \
    --size=200m --bs=2300 --runtime=30 --time_based | grep -E "IOPS=|sync \(usec\)|99.00th|99.50th"

echo "=== random 4k write ==="
fio --name=randw --rw=randwrite --bs=4k --size=1g --ioengine=libaio \
    --iodepth=32 --direct=1 --runtime=30 --time_based | grep -E "IOPS="

cd .. && rm -rf fio-test

````
