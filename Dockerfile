FROM public.ecr.aws/lambda/ruby:2.7 as builder

ENV LANG C.UTF-8

RUN yum update -y
RUN yum install -y \
    https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm \
    mysql-community-client mysql-devel lua-devel git \
    gcc make gcc-c++

WORKDIR /var/task

ADD ./Gemfile /var/task/Gemfile
ADD ./Gemfile.lock /var/task/Gemfile.lock
RUN bundle config set --local cache_all true \
    && bundle config --local without 'development test' \
    && bundle config set --local path 'vendor/bundle'
RUN bundle package
RUN bundle install

#

FROM public.ecr.aws/lambda/ruby:2.7 as handler

ENV LANG C.UTF-8
ENV BOOTSNAP_CACHE_DIR=/tmp/cache
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
ENV LUA_LIB=/usr/lib64/liblua-5.1.so
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=1

WORKDIR /var/task

ADD . .
COPY --from=builder /var/task/ .
COPY --from=builder /usr/lib64/mysql/ /usr/lib64/mysql/

CMD ["lambda.handler"]

#

FROM handler as updater

RUN yum install -y git

WORKDIR /var/task

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["bin/rails update:items"]
