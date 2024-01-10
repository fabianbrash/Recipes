```Initial Git Config```

````
git config --global user.name "Full Name"
git config --global user.email test@test.com
##List config
git config --list

##Also you can do this
git config --global --edit
````


#### and then if you need to change after you did a commit

````
git commit --amend --reset-author

#Clone repository
git clone http://repo or ssh:
#Add file
git add filename or git add *
#commit changes
git commit -m "Some text"
git push or git pull
#Get status
git status
#branches
git branch -a
#checkout a branch
git checkout <branchname>
````

```DELETE A BRANCH```

````
git branch -d <branchname>
````

### Changing branch from http/https to SSH

````
git remote -v ##List all our branches
git remote set-url origin git@github.com:USERNAME/REPOSITORY.git(Note you get this from the gitlab/github web ui)
````

#### If everything works you should be able to authenitcate with SSH keys if you've uploaded any

[https://help.github.com/articles/changing-a-remote-s-url/#switching-remote-urls-from-ssh-to-https](https://help.github.com/articles/changing-a-remote-s-url/#switching-remote-urls-from-ssh-to-https)


## NOTE THIS MUST BE DONE ON AN EMPTY REPO(TECHNICALLY) SO DON'T ADD A LICENSE FILE OR README FROM THE WEB UI

````
cd /path/with/code
git init
git add .
git commit -m "YOUR MESSAGE"
git remote add origin https://github.com/fabianbrash/movies-app.git ###OR whatever your empty REPO is called
git remote -v  ##See our remote repo's
git push -u origin master
````

#### Also we might want to push to an empty git repo

````
git init --initial-branch main

git add .

git commit -m "initial commit"

git push -u origin --all

````


## FROM GITHUB WHEN YOU GENERATE AN EMPTY REPO

````
echo "# movies-app" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/fabianbrash/movies-app.git
git push -u origin master

````

```Merge branches```

#### Here we will merge a branch called Jenkins into the master branch

````
git checkout master
git merge Jenkins
git push
````

#### If everything is good both master should now be merged with Jenkins

````
git log  ##See all commits

git log -p -2 ##Show all patches for the last 2 commits helpful to see what has changed and who changed it
````

#### You can also use git diff with git log to get changes

````
git log 
git diff commitID1 commitID2

##only show last commit
git log -1
````

#### Show the last commit hash

````
git log -1 --pretty=%H

## or

git log -1 --pretty=%h
````

```Tagging```

[https://git-scm.com/book/en/v2/Git-Basics-Tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

````
git tag

##search based on a pattern
git tag -l "v1.8.5*"

##Create an annoted tag
git tag -a v1.4 -m "my version 1.4"

git tag

git show v1.4

###Tag later

git log --pretty=oneline

git tag -a v1.2 9fceb02

````

```Sharing Tags```

#### By default, the git push command doesn’t transfer tags to remote servers. 

#### You will have to explicitly push tags to a shared server after you have created them. This process is just like sharing remote branches

#### you can run 

````
git push origin <tagname>.
````

````
git push origin v1.4
  
````

#### If you have a lot of tags that you want to push up at once, you can also use

#### the --tags option to the git push command. This will transfer all of your tags to the remote server that are not already there.

````
git push origin --tags
````

#### Remove a file or folder after it was committed and before you created a .gitignore file

[https://stackoverflow.com/questions/50675829/remove-node-modules-from-git-in-vscode](https://stackoverflow.com/questions/50675829/remove-node-modules-from-git-in-vscode)

````
##make .gitignore file.
##add node_modules/ line to gitignore file
##run this command 
git rm -r --cached .
git add .
git commit -m "remove gitignore files"
git push origin master
````


#### So I ran into this error and 'src refspec main does not match any So I ran

````
git show-refs

##output 

a8dcb34028342b837c8bbadb0c0aa49418ae4c48 refs/heads/master
````

#### and of course I was running

````
git push origin main
````

#### Well of course the issue was I hadn't run the command to rename master to main

````
git branch -M main
````

#### but a great command to troubleshoot 

````
git show-refs
````


```Renaming a branch```


#### The default branch has been renamed!

#### master is now named main

#### If you have a local clone, you can update it by running the following commands.

````
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a

````
