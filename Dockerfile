FROM ruby:2.6.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y
RUN apt-get install -y build-essential nano nodejs yarn sqlite3 default-mysql-client
RUN apt-get install -y liblua5.1-0 cron p7zip-full
RUN gem install bundler

ENV APP_ROOT /webapp
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
