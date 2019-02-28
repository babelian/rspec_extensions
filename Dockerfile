FROM ruby:2.5.3-alpine

# For Nokogiri
RUN apk add --update \
    build-base \
    ruby-dev \
    bash \
    git \
    less \
    nano


#
# Gems
#

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app