---
layout: page
title: Github-Pages
---
# Github Pages
    : vsplit
    https://jekyllrb.com/docs/step-by-step

## Links
- docs/dev.md

## Files
- \_config.yml
- github-pages.md
- index.md

## Install Jekyll
    $ sudo gem install jekyll bundler
    $ bundler init
    $ echo 'gem "jekyll"' >> Gemfile
    $ bundle
    $ bundle install

## Build and Test
    $ bundle exec jekyll build
    $ bundle exec jekyll serve

## Files
    .
    ├── 404.html
    ├── Gemfile
    ├── Gemfile.lock
    ├── _config.yml
    ├── _posts
    │   └── 2019-05-30-intro.md
    ├── _site
    │   ├── 2019
    │   │   └── 05
    │   │       └── 30
    │   │           └── intro.html
    │   ├── 404.html
    │   ├── assets
    │   │   ├── main.css
    │   │   └── minima-social-icons.svg
    │   ├── docs
    │   │   └── dev.md
    │   ├── feed.xml
    │   ├── github-pages.html
    │   ├── index.html
    │   └── tutorial
    │       ├── remote-docker.md
    │       ├── ssh-tunnel.md
    │       └── ubuntu-usb.md
    ├── docs
    │   └── dev.md
    ├── github-pages.md
    ├── index.md
    └── tutorial
        ├── remote-docker.md
        ├── ssh-tunnel.md
        └── ubuntu-usb.md

## Create a layout
    $ mkdir _layouts/
    $ touch _layouts/default.html
    $ touch about.md

## Create Index
    $ rm index.html
    $ touch index.md

## Navigation
    $ mkdir _includes/
    $ touch _includes/navigation.html

## Data
    $ mkdir _data/
    $ touch _data/navigation.yaml

## Blog Posts
    $ mkdir _posts/
    $ touch _posts/2019-05-30-intro.md
    $ touch _layouts/post.html
    $ touch blog.html


## Config
    $ touch _config.yml

## Syntax Highlighting
    $ sudo gem install kramdown rouge
