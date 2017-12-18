![mDNS enabled ejabberd](https://raw.githubusercontent.com/hausgold/docker-ejabberd/master/docs/assets/project.png)

This Docker images provides the [ejabberd](https://www.ejabberd.im/) as an development image
with the mDNS/ZeroConf stack on top. So you can enjoy the ejabberd service
while it is accessible by default as *ejabberd.local*.

**Heads up!** This image is dedicated to your development environment.
Do not run it on production!

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
ejabberd:
  image: hausgold/ejabberd
  environment:
    # Mind the .local suffix
    - MDNS_HOSTNAME=ejabberd.test.local
  ports:
    # The ports are just for you to know when configure your
    # container links, on depended containers
    - "4560" # (XMLRPC)
    - "5222" # (Client 2 Server)
    - "5269" # (Server 2 Server)
    - "5280" # (HTTP admin/websocket/http-bind)
    - "5443" # (HTTP Upload)
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

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
