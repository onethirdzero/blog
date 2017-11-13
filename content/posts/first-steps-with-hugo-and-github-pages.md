---
title: "First Steps with Hugo and Github Pages"
date: 2017-11-12T20:48:24-08:00
draft: false
---

I had a go at doing this a couple months ago, but for some reason, the Hugo docs were much easier to digest this time.

It's a good thing that I kept a list of Hugo themes I had my eye on from before, otherwise that rabbit hole would have eaten up the rest of my evening.

## The About Page

One of the first things I did with the standard Hugo scaffold was add an About page. I remember reading [Lynne Tye's Indie Hackers blog post](https://www.indiehackers.com/@lynnetye/d1042ffa5f) about how important a good About page is. It worked well for her, so I'm determined to make it work for me. Besides, more writing practice is always good.

I think Hugo considers `page` a built-in content section (not official terminology). By that, I mean that if you create a new file called `foo` under `content/page/`, you'll be able to assign a URL like `baseurl.com/foo` to it.

In the case of my About page, I was able to create `content/page/about.md` and route to it using `onethirdzero.github.io/about` through a main menu item, like so:

```
$ hugo new content/page/about.md
```

```toml
# config.toml

...

[[menu.main]]
name = "About"
weight = 0
identifier = "about"
url = "/about

...
```

Writing an About page is tough! Not knowing what I want to write is only half the story. The other challenge is being OK with sharing my story publically. I'll keep it short for now and add to it as I go.

## Deployment

The official Hugo docs have pretty sufficient instructions on [how to get a Hugo site published to Github Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/).

On my first attempt, I actually mistakenly set up my repo for a **project** Github Page so that this site was available at `http://onethirdzero.github.io/blog`. Not as pretty as just having the base URL!

On the bright side, I learned about [git worktrees](https://git-scm.com/docs/git-worktree) from that little adventure.

I eventually got around to [hosting on my own User Github Page](https://gohugo.io/hosting-and-deployment/hosting-on-github/#host-github-user-or-organization-pages). The docs even provide you with a nice script so you can deploy with one line without having to leave the root project directory.

If you're picky about whitespace and comment punctuation, feel free to use my version as a skeleton:

```bash
# deploy.sh
#!/bin/bash

echo -e "\033[0;32mDeploying updated site to GitHub User Page..\033[0m"
echo

# Build the project.
hugo -t minimo

# Go to public/ directory.
cd public

# Add changes to git.
git add .

# Default commit mesage.
msg="Rebuild site on [`date`]"

# If adding a custom commit message, accept only 1 argument.
if [ $# -eq 1 ]
  then msg="$1"
fi

# Push to submodule's remote.
git commit -m "$msg"
git push origin master

# Come back up to the project root.
cd ..

echo
echo "See your updated site at http://onethirdzero.github.io"

exit 0
```

## Hiccups

I was pleasantly surprised to be greeted by raw XML upon navigating to the hosted URL. After all, the site looked fine when served from the local webserver.

As it turns out, the published `public/` directory contained an `index.xml` instead of the expected `index.html`.

```xml
<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
<channel>
<title>Blog</title>
<link>http://onethirdzero.github.io/</link>
<description>Recent content on Blog</description>
<generator>Hugo -- gohugo.io</generator>
<lastBuildDate>Sun, 12 Nov 2017 17:55:15 -0800</lastBuildDate>
<atom:link href="http://onethirdzero.github.io/index.xml" rel="self" type="application/rss+xml"/>
<item>
<title>About</title>
<link>http://onethirdzero.github.io/about/</link>
<pubDate>Sun, 12 Nov 2017 17:55:15 -0800</pubDate>
...
```

This happens when you build [your Hugo site without a theme](https://stackoverflow.com/questions/25577157/use-hugo-to-render-html-files).

So, the fix is to specify a theme when calling `hugo`.

```bash
$ hugo --theme=themename
$ hugo -t themename # This works too.
```

However, that didn't work for me right away. Passing a `-v` flag to `hugo` exposed the problem.

```
INFO 2017/11/12 19:37:16 Using config file: /Users/jordan/blog/config.toml
WARN 2017/11/12 19:37:16 Unable to find static directory for theme minimo in /Users/jordan/blog/themes/minimo/static
WARN 2017/11/12 19:37:16 Unable to find Static Directory: /Users/jordan/blog/static/
WARN 2017/11/12 19:37:16 No static directories found to sync
...
```

If you've added your Hugo theme as a git submodule (best practice), you'll need to run `git submodule update` to pull the remote files to your local project so that `hugo` has access to them.

After doing that, the published site looked exactly like its local cousin.

## Retrospective

This was pretty cool to set up. Hugo made it easy to get started creating content and adding a theme. Plus, it's written in Go!

Using Github Pages was seamless too. Just name your repo `[your username].github.io`, push your deploy files and you've got a running site.

One of the things I'm excited about managing my own blog is being able to play with the deploy pipeline and infrastructure. For now, I'll settle for this Heroku-like process.

When I get the time, I'd like to experiment with a cloud provider and a proper CI pipeline. Sound like overkill? I think that's part of the fun.
