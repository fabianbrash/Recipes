```USEFUL TIPS FOR VIM OR VI```

#### ADD NUMBERS TO LINES

#### HIT ESC type ':' set number

### When you exit this setting will not persist to persist

##### in your home directory create a file called .exrc and add set number to it

##### You can also hit esc and type ':' set all to see all options available

[http://vimdoc.sourceforge.net/htmldoc/options.html](http://vimdoc.sourceforge.net/htmldoc/options.html)


```MY .exrc file```

````
set number
set autoindent
````


##### WHILE WORKING WITH .YAML FILES I RECEIVED THE BELOW ERROR MESSAGE

###### yaml: line 43: found character that cannot start any token

#### THE CAUSE WAS TABS WERE INSERTED IN THE FILE AND .YAML WANTS SPACES SO I HAD TO DO

#### ESC : set list so I could see the TABS which is showed up as ^I while spaces were $ so I simply just deleted

#### The ^I and I was good, I need to find a way to find and replace them all


```Global search and replace```

[https://vim.fandom.com/wiki/Search_and_replace](https://vim.fandom.com/wiki/Search_and_replace)

````
:%s/foo/bar/g    ##replace all occurences of foo with bar


: set list. ##VERY HELPFUL IN FINDING TABS IN A YAML FILE
````

```GLOBAL REPLACE \n```

````
:%s/\n/

````

[https://stackoverflow.com/questions/3983406/delete-newline-in-vim](https://stackoverflow.com/questions/3983406/delete-newline-in-vim)
