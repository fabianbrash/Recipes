```RAY setup```


```Python3 env setup```


````

cd myworking_dir

python3 -m venv /home/me/myworking_dir
source bin/activate

````


```Ray reqs```


````
pip3 install 'ray[default]'
##or
pip install 'ray[default]'==2.9.0
pip3 install urllib3
pip3 freeze > requirements.txt

````


#### Now because we are using a virtual env we need to make sure that when we schedule our ray job it doesn't upload any of our python directories


````
touch .gitignore
````

```.gitignore```

````
lib/
bin/
include/

````
