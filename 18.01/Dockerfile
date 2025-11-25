FROM ubuntu:18.04
LABEL org.opencontainers.image.authors="containers@hausgold.de"

# You can change this environment variable on run's with -e
ENV \
  DEBIAN_FRONTEND="noninteractive" \
  MDNS_HOSTNAME="ejabberd.local"

# Install system packages
COPY config/sources.list /etc/apt/sources.list
RUN apt-get update -yqqq && \
  apt-get install -y \
    avahi-daemon avahi-discover avahi-utils \
    libnss-mdns haproxy supervisor \
    ejabberd ejabberd-contrib \
    erlang-p1-mysql erlang-p1-pgsql erlang-p1-sqlite3

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/
RUN mkdir -p /var/log/supervisor

# Configure ejabberd
COPY config/ejabberd.yml /etc/ejabberd/ejabberd.yml

# Define the command to run per default
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
