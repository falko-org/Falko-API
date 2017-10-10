FROM ruby:2.4.1

MAINTAINER alaxallves@gmail.com


RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
&& apt-get install -y nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn postgresql-client

RUN mkdir Falko-2017.2-BackEnd
WORKDIR /Falko-2017.2-BackEnd

COPY . /Falko-2017.2-BackEnd

COPY Gemfile /Falko-2017.2-BackEnd/Gemfile
COPY wait-4-postgres.sh /Falko-2017.2-BackEnd/wait-4-postgres.sh

RUN chmod +x ./wait-4-postgres.sh

