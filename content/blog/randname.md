---
title: "randname"
date: 2017-12-03T14:58:36-08:00
draft: false
---

Last weekend, [I wrote a random name generator](https://github.com/onethirdzero/randname) after realizing [how simple one of these things was to write](https://github.com/phobologic/random_name).

Everyone knows that coming up with a game name is the hardest part of any game. I’m not proud of how long I spent thinking of one when I created my first Maple Story account many years ago.

I’ve used a couple online name generators before, but rolling my own and having it at my fingertips seemed like a cool idea.

The names it generates are `adjective-noun` style names (as used in Docker and Heroku) because I find those much more entertaining than single-word ones that sound like actual character names.

## Why Go?

Some co-workers of mine wrote [Atlantis](https://atlantis.run/) and [open sourced it](https://atlantis.run/blog/atlantis-release/) earlier this year. They rewrote it for open source in Go (from Python). Part of the reason for that was the easily redistributable binary that they could compile down to.

Before, the only experience I had with writing Golang was during course assignments. But I was inspired by Atlantis's success to give it another go.

I used to think that CLI apps had to be written in Bash. After all, that’s the environment that they’re run in.

Python and Node.js scripts can be run like CLI apps, but calling them with the parent binary prefixed doesn’t feel quite the same. And you need to include the file extension!

```bash
# Python.
$ python groovy_app.py

# Node.js.
$ node groovy_app.js

# Bash or Go.
$ groovy_app
```

Go allows the compiled output to be named however you want, so it's as close to a Bash script without a prefix, with all the features of a full programming language. Plus, it has a quickly growing community and has been consistently used for many high-profile projects.

## Using a framework

One of our internal tools used a popular CLI framework for Go, which had easy-to-digest code, so I decided to give it a shot.

At the time, I was unaware of [`cobra`](https://github.com/spf13/cobra), which Kubernetes and Hugo were based on. Looking back, it would have been nice to be associated with `cobra`'s fame, but it shouldn't matter in the long run. I'm also lazy, so I'd rather delay considering other frameworks until I hit real limitations.

Nonetheless, it was super easy to get up and running, as laid out by the docs.

```bash
$ go get gopkg.in/urfave/cli.v1
```

I decided to pin to `v1`,  since its eventual successor `v2` is considered unstable at the time of this writing.

The main thing I liked about using a CLI framework was the support for implementing flags. This was awesome because I didn’t have to write my own parser and handlers.

## Naming

It’s ironic that I had problems naming a name generator. I initially called this project `rand_name_gen`, but according to [this Go blog post](https://blog.golang.org/package-names), the underscores were not recommended. Also, the project's name should be as short as possible.

After playing around with a couple permutations (`rname`, `randnamegen`, `rnamegen`, etc.) and sourcing opinions from peers, I settled on `randname` for the sole reason that a method called `randname.Generate()` would flow nicely and semantically.

Naming is hard.

## Next steps

I originally intended this to be used as a standalone binary, but I just realized that this could be tweaked a little to become a proper Go package as well.

I’d also like to try to pull new adjectives and nouns from outside sources, just to switch things up. That will be an avenue for learning the standard Go networking client.

Considering its simplicity, the project would probably have a tiny testsuite. However, that would be a good first foray into writing tests.

Also, I caught a glimpse of Circle CI configs somewhere in the Atlantis repo, so that's piqued my interest in doing something similar here.

Time will tell if I eventually follow up on these.
