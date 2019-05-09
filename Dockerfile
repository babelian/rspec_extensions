FROM ruby:2.6.0-alpine

RUN apk add --update \
    build-base \
    ruby-dev \
    git

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app

CMD rake spec