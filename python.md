## Python knowledge goes here

## Creating a virtual env on linux

### You might need to install a package on ubuntu, it should tell you what the missing package is

```REFS```

[stackoverflow](https://stackoverflow.com/questions/31252791/flask-importerror-no-module-named-flask)

[python3 docs on virtual env](https://docs.python.org/3/library/venv.html)

[DO tutorials](https://www.digitalocean.com/community/tutorials/how-to-use-variables-in-python-3)

[Programiz tutorials](https://www.programiz.com/python-programming/list-vs-tuples)

[Python Flask API tutorial](https://programminghistorian.org/en/lessons/creating-apis-with-python-and-flask)

[Freecodecamp Tutorial](https://www.freecodecamp.org/news/if-name-main-python-example/)

[PipEnv-Fork](https://pipenv-fork.readthedocs.io/en/latest/basics.html)

````
mkdir -p /home/me/backend/flask-app
python3 -m venv /home/me/backend/flask-app
source bin/activate ## source only work in Linux/MAC for Windows in the virtual env there should be a Scripts directory with an activate batch script
````

## After runing the above your command line should now show flask-app in the name of the command like so (flask-app)... that's the hint it's working

```Install packages```

````
pip3 install flask flask-cors

pip3 freeze > requirements.txt
````

### If you did everything correctly the requirements.txt file should only have a few packages, you should not see a ton, that's a dead giveaway that you're not in our virtual env but you froze the entire system packages

##

```pipenv```

````
sudo pip3 install pipenv

mkdir fastapi-crud
cd fastapi-crud
pipenv shell

pipenv install fastapi uvicorn
````
##

### Note if you open the shell in the wrong terminal session just close everything out and run pipenv shell again

### List all modules

````
python3

print(help('modules'))
````

#### Note CTRL+D to close out on Linux and MAC or type exit() exit() should also work on Windows


#### You might have to do this from time to time

````
cd myapp
mkdir lib

pip3 install -r requirements.txt -t lib/

// also

pip3 install fastapi uvicorn requests -t lib/
````

#### The above will install all requirements into the lib folder or the second example all packages into lib

