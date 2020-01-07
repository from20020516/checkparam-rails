FROM ruby:2.7.0

WORKDIR /var/www/html
#
RUN apt-get update -y
RUN apt-get install -y build-essential nano nodejs yarn sqlite3 default-mysql-client liblua5.1-0 cron p7zip-full
#
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#
ADD Gemfile /var/www/html
RUN gem install bundler
RUN bundle install
RUN rails db:migrate
