---
title: "Challenges in making WSL 2 run services at Windows startup"
date: 2022-05-14T23:52:23-07:00
draft: false
---

## Background

I've been running WSL since mid 2020 as a thin client to my Linux workstation and it's mostly worked well so far.

As I finally had more time to tinker at home, I wanted to configure the init system on my WSL host to start cron when my Windows machine boots.

I'm currently running Ubuntu 20.04 via WSL 2.

[Proof from PowerShell](https://askubuntu.com/a/1177730):

```console
PS C:\Users\Jordan> wsl -l -v
  NAME            STATE           VERSION
* Ubuntu-20.04    Running         2
```

Proof from within the WSL host:

```console
❯ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.1 LTS
Release:        20.04
Codename:       focal

❯ uname -a
Linux kamino 4.19.104-microsoft-standard #1 SMP Wed Feb 19 06:37:35 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
```

However, it's not that straightforward to get things to work.

## Problem 1

WSL is not started automatically when Windows boots. This means that if my computer restarts after a Windows Update, my WSL host won't boot itself back up.

We need to configure Windows to start WSL for us — details are in the [workaround section below](#workaround).

## Problem 2

However, even after WSL has started, the `cron` service is not started according its init.d script metadata.

> **Note:** At the time of writing, Ubuntu 20.04 in WSL 2 still runs a custom sysvinit instead of systemd by default — because of [issues under the hood](https://github.com/microsoft/WSL/issues/994) — so services in a vanilla install are configured via `/etc/init.d` scripts.

Like many other WSL hosts, mine is not running systemd:

```console
❯ systemctl
System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down

❯ ps -p 1
  PID TTY          TIME CMD
    1 ?        00:00:00 init
```

Here's the cron init.d script in question:

```
❯ head -n18 /etc/init.d/cron
#!/bin/sh
# Start/stop the cron daemon.
#
### BEGIN INIT INFO
# Provides:          cron
# Required-Start:    $remote_fs $syslog $time
# Required-Stop:     $remote_fs $syslog $time
# Should-Start:      $network $named slapd autofs ypbind nscd nslcd winbind sssd
# Should-Stop:       $network $named slapd autofs ypbind nscd nslcd winbind sssd
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Regular background program processing daemon
# Description:       cron is a standard UNIX program that runs user-specified
#                    programs at periodic scheduled times. vixie cron adds a
#                    number of features to the basic UNIX cron, including better
#                    security and more powerful configuration options.
### END INIT INFO
```

We can see that the cron init.d script has [Default-Start](https://refspecs.linuxbase.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/initscrcomconv.html): `2 3 4 5`.

I would expect my WSL host to be either [runlevel](https://en.wikipedia.org/wiki/Runlevel#Linux_Standard_Base_specification):

- `3: Multi-user mode with networking`, or
- `5: Full mode	; Same as runlevel 3 + display manager`

So in theory, this should just work since the init system is running.

However, it looks like runlevel still [isn't supported](https://unix.stackexchange.com/a/458388) in Ubuntu 20.04 despite WSL 2 running a full Linux kernel:

> Unfortunately as of today (2022-01) runlevels are still not supported in the default WSL Ubuntu 20.04.

So, my guess is that without a working runlevel, sysvinit won't run init.d scripts even if they've been installed to the right runlevel. For example, we can see that on my host:

```console
❯ runlevel
unknown

❯ ls -l /etc/rc3.d/S01cron
lrwxrwxrwx 1 root root 14 Apr 22  2020 /etc/rc3.d/S01cron -> ../init.d/cron

❯ ls -l /etc/rc5.d/S01cron
lrwxrwxrwx 1 root root 14 Apr 22  2020 /etc/rc5.d/S01cron -> ../init.d/cron
```

## Workaround

The good news is that the community has figured out [a bunch of ways](https://superuser.com/questions/1343558/how-to-make-wsl-run-services-at-startup) to get around these limitations.

The general approach in all these solutions are to:

1. Update the `sudoers` file in the WSL host to allow a target user to run `service` commands in the host without a password.
2. Configure Windows to start WSL and run those `service` commands — or a script that wraps them — when Windows boots.

I ended up using [this approach](https://superuser.com/a/1514776). While this got things working for me, I'd like to see this experienece improved in future versions of WSL.

Apparently WSL on Windows 11 supports a `[boot]` [section](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#boot-settings) in `wsl.conf`, which removes the need to update the WSL host's `sudoers` file. However, I'm not ready to upgrade to Windows 11 yet, so this will be my setup for now unless Microsoft decides to backport this to Windows 10.

## Further reading

The more that I dug into the runlevel issue in WSL, the more convinced I became that I'm using WSL for something it's still not designed for in its current state.

- https://github.com/microsoft/WSL/issues/573
- https://github.com/Microsoft/WSL/issues/1761#issuecomment-393154803
- https://github.com/microsoft/WSL/issues/1761#issuecomment-393054831

I don't have an issue with this, since this was all for fun and learning anyway. It was just convenient to be able to poke around more Linux stuff while I'm already at my Windows computer.

Looks like I'll be dusting off that Raspberry Pi soon.
