FROM ruby:2.6-slim

ENV RUBY_VERSION 2.6
#ENV PG_MAJOR 10

#RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
#RUN apt-get update -q && apt-get install -yq wget ca-certificates
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# install packages
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential ruby-dev bundler libxml2-dev libcurl4-openssl-dev vim postgresql-client-11 && \
    rm -rf /var/lib/apt/lists/*

# Volumes - data to backup will be mapped to /data
VOLUME ["/data"]

# Copy App
COPY . /root/Backup
WORKDIR /root/Backup
RUN gem install http_parser.rb && gem install unf_ext -v '0.0.6' && bundle install


COPY bin/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
