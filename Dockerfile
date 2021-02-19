FROM public.ecr.aws/lambda/ruby:2.7

ENV LANG C.UTF-8

RUN yum update -y
RUN yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
RUN yum install -y mysql-community-client mysql-devel lua-devel git
RUN yum install -y gcc make gcc-c++

ENV BOOTSNAP_CACHE_DIR=/tmp/cache
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
ENV LUA_LIB=/usr/lib64/liblua-5.1.so
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=1
ENV RAILS_SERVE_STATIC_FILES=1

WORKDIR /var/task

ADD ./Gemfile /var/task/Gemfile
ADD ./Gemfile.lock /var/task/Gemfile.lock
RUN bundle config set cache_all 'true' \
    && bundle config set path 'vendor/bundle' \
    && bundle config without 'development test'
RUN bundle package

ADD . /var/task
RUN bundle install
RUN ./bin/rails assets:clean
RUN ./bin/rails assets:precompile

RUN yum remove -y gcc make gcc-c++ git

CMD ["lambda.handler"]
