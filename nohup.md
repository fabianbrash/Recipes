```nohup examples```




````
sudo nohup radm dependency --config config.yaml > ./dependency.log

sudo nohup radm application --config config.yaml > ./application.log

nohup ./long_job.sh >> job_results.log 2>&1 &

````
