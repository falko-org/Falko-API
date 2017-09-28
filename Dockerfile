FROM ruby:2.4.1

MAINTAINER alaxallves@gmail.com

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y nodejs mysql-client postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN bundle config --global frozen 1\
    bundle install --without development test

COPY . /usr/src/app

RUN bundle exec rake DATABASE_URL=postgresql:does_not_exist assets:precompile

CMD bundle install \
    bundle exec rake db:create; \
    bundle exec rake db:migrate; \
    bundle exec rails s -p 3000 -b '0.0.0.0';

