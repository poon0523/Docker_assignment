# テキストのバージョンであるRuby3.0.1に揃える
FROM ruby:3.0.1

ENV RAILS_ENV=production

ARG UID=1000
RUN useradd -m -u ${UID} docker
 
 
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

 
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /docker_blog4
WORKDIR /docker_blog4
COPY Gemfile /docker_blog4/Gemfile
COPY Gemfile.lock /docker_blog4/Gemfile.lock
RUN bundle install
COPY . /docker_blog4
RUN chmod -R ugo+rw /docker_blog4/tmp


# コンテナ起動時に毎回実行する
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

USER ${UID}
# rails s　実行.
CMD ["rails", "server", "-b", "0.0.0.0"]