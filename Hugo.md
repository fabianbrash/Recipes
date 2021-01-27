## Hugo

[Hugu quickstart](https://gohugo.io/getting-started/quick-start/)

[Unofficial Docker Image](https://hub.docker.com/r/klakegg/hugo/)

[JamStack Themes](https://jamstackthemes.dev/ssg/hugo/)

[Flaviscopes Hugo Tutorial](https://flaviocopes.com/start-blog-with-hugo/)

## Create a new project

````
hugo new site quickstart

````

## Add a theme

````
cd quickstart
git init
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke

````

## Add theme to our config

````
echo 'theme = "ananke"' >> config.toml
````

## Add some content

````
hugo new posts/my-first-post.md
````

## Start the hugo server -D means show draft posts

````
hugo server -D
````

## Now let's build our static site again the -D means show drafts the static files will be outputted to ./public

### Output will be in ./public/ directory by default (-d/--destination flag to change it, or set publishdir in the config file).

````
hugo -D

hugo
````
