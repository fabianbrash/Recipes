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
##

### Add your own custom css to a hugo template, note check your template to see if they have already added the below code

````
// css 
{{ range .Site.Params.custom_css }}
    <link rel="stylesheet" href="{{ . | absURL }}">
{{ end }}

// javascript
{{ range .Site.Params.custom_js }}
    <script type="text/javascript" src="{{ . | absURL }}"></script>
{{ end }}
````

### The Ananke template already had the css import code at the bottom of /themes/ananke/layouts/partials/site-style.html again each theme will be different
### Then add this to your config.toml file

````
[params]
  custom_css = ["css/custom.min.css"]
````
### Note the above is an array so you can comma separate and add more css files
### Found this help from [banjocode.com](https://www.banjocode.com/custom-css/)

```Hugo cloning issues```

##### Everytime I clone the repo that has my hugo site to a new machine I would receive errors like the below when I tried to build my site or run hugo in dev mode

````

WARN 2024/02/06 07:26:21 found no layout file for "html" for kind "page": You should create a template file which matches Hugo Layouts Lookup Rules for this combination.
````

##### I couldn't figure out what was the issue, well a quick Google and I have a resolution.  After cloning any hugo repo since the themes use git submodules you need to run the below after cloning

````
git submodule init
git submodule update

hugo server -D  #serve up our site in dev mode and load draft posts
````

##### That's it all those errors should go away. Git submodules are a bit of a black box to me

[https://stackoverflow.com/questions/60269683/how-to-fix-the-error-found-no-layout-file-for-html-for-page-in-hugo-cms](https://stackoverflow.com/questions/60269683/how-to-fix-the-error-found-no-layout-file-for-html-for-page-in-hugo-cms)
