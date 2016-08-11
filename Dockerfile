FROM ubuntu-debootstrap:14.04

ENV RUBY_VERSION 2.3
ENV PG_MAJOR 9.5

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C3173AA6 \
    && echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main > /etc/apt/sources.list.d/brightbox-trusty-ng-trusty.list \
    && apt-get update -q && apt-get install -yq gzip autoconf bison build-essential libreadline6-dev zlib1g-dev libncurses5-dev libssl-dev libyaml-dev openssl ca-certificates libpq-dev libreadline-dev \
       --no-install-recommends \
       ruby$RUBY_VERSION \
       ruby$RUBY_VERSION-dev

RUN echo 'gem: --no-ri --no-rdoc' > /etc/gemrc && \
    gem install bundler --no-rdoc --no-ri && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cat /dev/null >|  /var/log/*log

# install packages
RUN apt-get update && \
    apt-get install -y ruby-dev vim "postgresql-client-$PG_MAJOR" && \
    rm -rf /var/lib/apt/lists/*

# Volumes - data to backup will be mapped to /data
VOLUME ["/data"]

# Copy App
COPY . /root/Backup
WORKDIR /root/Backup
RUN gem install nokogiri && gem install http_parser.rb && gem install unf_ext -v '0.0.6'  && bundle install


COPY bin/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
