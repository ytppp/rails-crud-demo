FROM ruby:3.2.2

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev \
  libvips42 \
  postgresql-client \
  build-essential \
  curl

ARG NODE_MAJOR=18
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

RUN apt-get update -qq && apt-get install -y nodejs && npm install -g yarn

RUN gem install bundler -v 2.4.8 && \
  bundle config set --local path vendor/bundle

WORKDIR /app