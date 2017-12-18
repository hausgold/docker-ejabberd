FROM debian:stable
MAINTAINER Henning Vogt "henning.vogt@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=ejabberd.local

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y \
    ejabberd

# Copy ejabberd.cfg
COPY config/ejabberd.cfg /etc/ejabberd/ejabberd.cfg

EXPOSE 5222
EXPOSE 5269
EXPOSE 5280

RUN service ejabberd restart

RUN ejabberdctl register admin localhost defaultpw
