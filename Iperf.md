```THIS IS MY CONFIG FOR RUNNING IPERF I'M SURE THERE ARE BETTER, BUT THIS WORKS FOR ME```


```SERVER CONFIG```

````
iperf3 -s -f m
````

```CLIENT CONFIG```

````
iperf3 -c 'IP of server' -f m -t 480 -4
````

```THE ABOVE COMMANDS ARE ALSO WHAT I USE ON LINUX```

```10G Config```


```
iperf3 -c 'IP of server' -f m -t 480 -4 -w 384K
I was able to get 7.6Gb/s using MTU=1500

```

```MULTITHREADED```

````
iperf3 -c 'IP of server' -f m -t 480 -4 -P 4 -w 4096K
````


```ALSO THIS WORKED PRETTY WELL```

````
iperf3 -c 'IP of server' -f m -t 480 -4 -w 256K
````

```AWWW SIMPLICITY```

````
iperf3 -c 'IP of server' -t 480 -P 2 -w 512K -O 2
````

```CPU```

````
WATCH CPU ESPECIALLY IN VM'S I NOTICED POOR PERFORMANCE IF ONE OF THE VM'S CPU WAS BUSY
FOR RSS SET BASE PROCESSOR TO PROC 1 NOT 0 AS 0 IS USED MOSTLY BY OS
SO BASEPROC=1 MAXPROC=4(NOTE YOU CAN'T SAY 3 ON VMXNET3)
````
