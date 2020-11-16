FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs vim

RUN mkdir /mail_test
WORKDIR /mail_test

# ホストのGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /mail_test/Gemfile
COPY Gemfile.lock /mail_test/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . /mail_test

# puma.sockを配置するディレクトリを作成
RUN mkdir tmp/sockets