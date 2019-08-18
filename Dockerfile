FROM ruby:2.6.3

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nano nodejs yarn && gem install bundler
RUN apt-get install -y cron liblua5.1-0

ENV APP_ROOT /webapp
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

# ADD ./Gemfile $APP_ROOT/Gemfile
# ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock
# RUN bundle install

ADD . $APP_ROOT

# RUN mkdir -p tmp/sockets
# RUN rails new . --force --skip-bundle
# RUN bundle exec whenever --update-crontab

CMD ["cron", "-f"]
