---
layout: default
title: About
---
# Github Pages
    : vsplit
    https://jekyllrb.com/docs/step-by-step

## Links
- <docs/dev.md>

## Install Jekyll
    $ sudo gem install jekyll bundler
    $ bundler init
    $ echo 'gem "jekyll"' >> Gemfile
    $ bundle

## Build and Test
    $ bundle exec jekyll build
    $ bundle exec jekyll serve

## Files
    $ tree .

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
