FROM ruby:2.6.0-alpine

RUN apk add --update \
    build-base \
    ruby-dev \
    git \
    && gem install bump

RUN mkdir -p /app
WORKDIR /app
COPY lib/rspec_extensions/version.rb /app/lib/rspec_extensions/version.rb
COPY Gemfile Gemfile.lock *.gemspec /app/
RUN bundle install

COPY . /app

CMD rake spec