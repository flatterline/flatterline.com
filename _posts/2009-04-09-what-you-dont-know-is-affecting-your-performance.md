--- 
author: Chris Chandler
excerpt:
  Want to eek a little performance out of your current hosting setup? Follow
  these easy steps to decrease swapping.
layout: post
title: What you don't know is affecting your performance
tags: 
- technology
---

Does your Linux-based virtualized hosting feel a little slow? Does it suffer from preemptive swapping? Here's a quick tip on getting some more performance out of your current setup. This is especially useful if you have a significant ratio of physical RAM to in-memory programs.

### Swappiness

The Linux 2.6 kernel has a parameter called vm.swappiness that regulates the kernel's likelihood to swap memory to disk (e.g., to free up memory for disk/content caching, load other programs, etc). Valid values are between 0 and 100. On the current release of Ubuntu (Intrepid) this value has a default value of 60 that you can investigate with the following command:

    $ cat /proc/sys/vm/swappiness
    60

This value is generally fine, but if your physical memory is significantly higher than what you need it's worth investigating other choices.I personally find a pretty significant performance increase in Rails behavior with a value of 0; essentially telling the kernel to not swap anything out until it becomes absolutely necessary.

The value can be changed either with:

    $ sysctl vm.swappiness=0

**or**

    $ echo 0 &gt; /proc/sys/vm/swappiness

### A persistent lack of swappiness

If you restart the server, then your change will be lost. If you want the change to remain persistent across restarts you'll either need to create a script that calls one of these commands or edit /etc/sysctl.conf to specify the swappiness. As always, exercise caution playing with kernel parameters :-).

### Swapping it back in

If you change vm.swappiness and want to force the kernel to swap everything back in you can temporarily disable the swap partition and then immediately re-enable it.

    $ swapon -s

    Filename         Type      Size  Used  Priority
    /dev/sda2         partition    524280 33948  -2

    $ swapoff /dev/sda2
    $ swapon /dev/sda2

If the machine doesn't have enough memory to accommodate the swap-in the command will fail with an error.

**Let us know if this helps you out!**
