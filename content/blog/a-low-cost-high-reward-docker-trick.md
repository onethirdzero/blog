---
title: "A Low Cost, High Reward Docker Trick"
date: 2018-01-30T20:30:54-08:00
draft: false
---

A [friend of mine](https://twitter.com/mohitg_) showed me this trick for quickly debugging Docker containers with failing [entrypoints](https://docs.docker.com/engine/reference/builder/#entrypoint).

Imagine you've got a container that won't start properly. You've had a look at the entrypoint script, but can't tell where the problem is just by looking.

One way to debug this would be to comment out suspicious lines, build the image and run the container to test your assumption. But there's a faster way.

Instead of going through that cycle — which quickly becomes tedious with large scripts — you could just do:

```bash
# Feel free to replace 30000 with an arbitrary number of seconds.
$ docker run -d --entrypoint sleep onethirdzero/foo 30000
```

This suspends the running of the entrypoint script and runs `sleep 30000` instead. If you have a copy of the entrypoint script nearby, you can `docker exec` into your container and run it line by line to narrow down the problem.

```bash
$ docker ps
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS               NAMES
e5babffcb646        onethirdzero/foo   "sleep 30000"       15 seconds ago       Up 2 seconds        5000/tcp            cranky_blackwell

$ docker exec -ti e5babffcb646 bash
$ cat entrypoint.sh
#!/bin/sh
/usr/bin/fsconsul -configFile=/etc/fsconsul/fsconsul.json &
/usr/bin/consul-template -o /etc/consul.d/templates/config.json.tpl /etc/consul.d/config.json &
nginx -g "daemon off;"

$ /usr/bin/fsconsul -configFile=/etc/fsconsul/fsconsul.json
# Diagnose.

$ /usr/bin/consul-template -o /etc/consul.d/templates/config.json.tpl /etc/consul.d/config.json
# Diagnose more.
...
```

You can then make the bug fix inside the container and test it line by line too. Much more pleasant than running through the build and run process each time!
