FROM ruby:2.3.3

RUN echo 'force update v=0'

RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn cron

RUN mkdir /myapp
WORKDIR /myapp

COPY ./Gemfile /myapp/
COPY ./Gemfile.lock /myapp/
RUN bundle install

ENV RAILS_ENV development
ENV DB_HOST postgres
ENV DB_USER postgres
ENV DB_PASSWORD postgres
ENV REDIS_PORT_6379_TCP_ADDR redis
ENV REDIS_PORT_6379_TCP_PORT 6379

COPY ./docker/bin/* /usr/local/bin/

COPY . /myapp

RUN yarn install
RUN rake assets:precompile
RUN whenever --update-crontab 'quero-votar' --roles app_master

EXPOSE 3000
