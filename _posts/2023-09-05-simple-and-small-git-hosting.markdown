---
layout: single
title: Simple and Small Git Hosting
date: 2023-09-05T11:31:02-04:00
---

There are regular discussions on the fediverse about self-hosted git, and they generally cover 
software that provides a similar experience to GitHub. Gitea and GitLab are the two names that I 
see with the most frequency.

We personally have a family Gitea instance, and I like it a lot! It is heavy software, though,
and can cost a decent bit to keep going. I want to cover an alternative that will work out much 
cheaper, with less administrative hassle. If you don't need all of the additional features software
like Gitea provides (Issue Tracker, Kanban boards, Wiki, etc.), bare git repos may serve you very 
well.

I'll cover some different ground today, and this post should serve more as a choose-your-own-adventure 
(with less grues, hopefully). There are many ways to use git, based on your needs, and your own 
judgment should lead you to the solutions that will work for you.

# What's a Bare Repo?

```
.
└── full_repo
    └── .git
        ├── branches
        ├── config
        ├── description
        ├── HEAD
        ├── hooks
        ├── info
        ├── objects
        └── refs
```

In a normal git repository, all of your versioning information is stored in the `.git` folder 
inside your project. Your working copy lives in the main folder (full_repo), where you do your work,
commit, switch branches, resolve merge conflicts, etc. If this isn't familiar, I would recommend
starting with a different  resource to learn the [fundamentals of git](https://www.git-scm.com/).

```
.
├── bare_repo
│   ├── branches
│   ├── config
│   ├── description
│   ├── HEAD
│   ├── hooks
│   ├── info
│   ├── objects
│   └── refs
```

A bare repo moves everything in the `.git` folder up one directory. The entire folder *is the git
repository*. This means that you can't have a working copy in this folder - the only things in here
are branches, tags, commits and other atomic git goodies!

> As an aside, you can also `git clone` and `git pull` from a non-bare repository, but you cannot
> `git push`.

Git will operate on remote repositories over different transport protocols. Gitea, GitLab and Github
support ssh and https transport. Git will also operate on 'remote repositories' on the same
filesystem! It really doesn't care either way.

For example:

```
$ git init --bare bare_repo
Initialized empty Git repository in /home/foobar/bare_repo/
$ git clone ./bare_repo cloned_repo
Cloning into 'cloned_repo'...
```

This will create a bare repo with no working copy, and a full clone with a working copy.
In the cloned version, there's an `origin` remote preconfigured:

```
~/cloned_repo$ git remote -v
origin   /home/foobar/./bare_repo (fetch)
origin   /home/foobar/./bare_repo (push)
```

This is just an example, but you may be happy to stop here. When you're in `cloned_repo`, you can
`git push` your commits and they'll just get pushed to the other folder. No remote server needed.

# SSH! It's time for Transports

`git clone` supports quite a few different transport protocols for operating on remote repositories.
It supports ssh, git, http(s), and (s)ftp. I'm going to focus on ssh and https today.

If you have ssh access to a server, you have SSH transport available. You can use an SCP-like syntax
to clone a repository. Assume that what we did above was running on a remote server, on your LAN
at `127.0.0.5`. You can clone it like so:

```
$ git clone foobar@127.0.0.5:~/bare_repo
```

This will behave exactly the same way as when we did it with a folder. The difference is, when you go
to `git push` or `git pull`, it will go over SSH transport, and you'll be asked to authenticate.
This is the transport you're already using if you're familiar with Gitea or similar software. It's a
feature of `git`, all on its own, no big web frontend needed. 😁

# HTTPS

If you want to serve a read-only copy, just stick your repo in a folder that's served by nginx or
your web server of choice. This is just an endpoint, like using SSH
transport above. You can `git clone` or `git pull` from the URL, but there is no web frontend.

You will need to regularly run
[git update-server-info](https://git-scm.com/docs/git-update-server-info)
to (re)generate auxiliary information files so that `git` can properly discover what is hosted
on your HTTPS endpoint.

If you *do* want a web frontend, git comes with 
[GitWeb](https://git-scm.com/book/en/v2/Git-on-the-Server-GitWeb).
I'm covering a lot of ground in this post, though, and don't want to cover too many topics at once.
Hopefully the documentation I've linked is sufficient to help you set up GitWeb, if you're so inclined.

# IP Addresses are Annoying!

IP Addresses are not easily human-parseable. They're harder to remember than domain names. Having some
kind of DNS resolution on your local network is a huge quality of life improvement. I'll provide two
solutions for DNS resolution, and you can pick which one you'd like based on your use case and comfort
with service configuration.

## Avahi / Zeroconf

[Zeroconf](https://en.wikipedia.org/wiki/Zero-configuration_networking)
(Zero-Configuration Networking) is a set of technologies that allows for broadcasting DNS information
directly from the client (your server, in this case), using 
[multicast DNS](https://en.wikipedia.org/wiki/Multicast_DNS).

The specific implementation that you'll be using is [Avahi](https://www.avahi.org/). The setup process
should be similar on different distributions of linux, but I'll cover setup on Debian and derivatives.

```
$ sudo apt-get install avahi-daemon
$ sudo systemctl start avahi-daemon
```

That's all that you need for DNS resolution. Your server is now broadcasting its domain name.

Great, but what is it? It's based on your hostname.

```
$ hostname
baz
```

Avahi will broadcast on the multicast
[TLD](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains)
`local`. Your server should be available at `(hostname).local`. In this example you should be
able to connect to `baz.local`.

## Local DNS Server

If you don't want to use multicast DNS, running your own domain name server is an option. I personally
use [unbound](https://en.wikipedia.org/wiki/Unbound_(DNS_server)).

Configuration of unbound is highly dependent on your network configuration and it would not be possible
for me to cover every permutation. Consider this the advanced method.

> Some software, such as [pfsense](https://pfsense.org), simplifies the operation of a DNS resolver
> greatly. If you're running pfsense, I would highly recommend taking a look at their documentation
> about [DNS resolver configuration](https://docs.netgate.com/pfsense/en/latest/services/dns/resolver.html).
> Similarly, if you're running open-wrt, there is documentation to 
> [configure a local DNS server](https://openwrt.org/docs/guide-user/base-system/dhcp).

# The Barest of Bare-bones Git Hosting

With DNS or zeroconf set up, all the pieces are in place. Revisiting the example from the transport
section, you can (for example) clone your repository now by running:

```
$ git clone foobar@baz.local:~/bare_repo
```

Your remote `origin` will be pre-populated, and you can interact with it from the command-line in
all of the regular ways.

> If your username is the same on both your local machine and server, you can omit `username@`

# Summary

There are a lot of reasons you might need something heavier, like Gitea, but there are a lot of 
situations where you don't. I use this setup in addition to our gitea instance, as not every
repository needs to be a full *project*, but I still want to stash an authoritative copy somewhere.

To recap, we've covered:
* Bare git repositories
* Git remotes, both local and over the network
* Transport protocols for git
* Domain name resolution

Running a bare SSH transport server like this is incredibly lightweight - I can get away with
only 2GB of RAM provisioned for my backup server. This can translate into real savings, especially
if you're running a cloud VPS.

> If you need some more features than bare repositories can provide,
> [Gitolite](https://gitolite.com/gitolite/)
> has been recommended to me. I haven't personally used it, and can't speak from firsthand
> experience, but it may fit your needs nicely.

I hope this was helpful! Always be n00bin. 👩‍💻
