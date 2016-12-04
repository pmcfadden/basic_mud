FROM ruby:2.3.3

ENV APP_HOME /code

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Headers needed
RUN apt-get update && apt-get install -y libpq-dev postgresql-server-dev-9.4 lua5.1 liblua5.1-0
ENV LUA_LIB /usr/lib/x86_64-linux-gnu/liblua5.1.so.0

COPY Gemfile* $APP_HOME/
COPY *.gemspec $APP_HOME/
COPY lib/classless_mud/version.rb $APP_HOME/lib/classless_mud/

RUN bundle install

EXPOSE 2000

COPY . $APP_HOME/

CMD ./bin/classless_mud start
