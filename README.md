![mDNS enabled ejabberd](https://raw.githubusercontent.com/hausgold/docker-ejabberd/master/docs/assets/project.svg)

[![Continuous Integration](https://github.com/hausgold/docker-ejabberd/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-ejabberd/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-ejabberd)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/ejabberd/)

This Docker images provides the [ejabberd](https://www.ejabberd.im/) as an development image
with the mDNS/ZeroConf stack on top. So you can enjoy the ejabberd service
while it is accessible by default as *ejabberd.local*.

**Heads up!** This image is dedicated to your development environment.
Do not run it on production!

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [docker-compose usage example](#docker-compose-usage-example)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [Further reading](#further-reading)

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

You just need to run it like that, to get a working ejabberd service:

```bash
$ docker run --rm hausgold/ejabberd
```

The port 5280 is proxied by haproxy to port 80 to make *ejabberd.local*
directly accessible. So you can use the HTTP WebSockets
(*ejabberd.local/websocket*) and Admin panel (*ejabberd.local/admin*)
directly.

The admin user is **admin@MDNS_HOSTNAME**, so by default it is
`admin@ejabberd.local` with the password `defaultpw`.

## docker-compose usage example

```yaml
services:
  ejabberd:
    image: hausgold/ejabberd
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: ejabberd.test.local
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/ejabberd
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/ejabberd
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
