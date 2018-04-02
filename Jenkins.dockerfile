FROM ruby:2.3.3
RUN echo "wtf"

RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn
RUN yarn config set cache-folder /root/.yarn-cache

ENV PHANTOM_JS_VERSION phantomjs-2.1.1-linux-x86_64

# Install phantomjs
RUN apt-get update && apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
RUN wget -q "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS_VERSION.tar.bz2" -O "$PHANTOM_JS_VERSION.tar.bz2"
RUN tar xvjf "$PHANTOM_JS_VERSION.tar.bz2"
RUN if [ -d "/usr/local/share/$PHANTOM_JS_VERSION" ]; then rm -rf "/usr/local/share/$PHANTOM_JS_VERSION"; fi
RUN mv -f "$PHANTOM_JS_VERSION" /usr/local/share/
RUN ln -sf "/usr/local/share/$PHANTOM_JS_VERSION/bin/phantomjs" /usr/local/share/phantomjs
RUN ln -sf "/usr/local/share/$PHANTOM_JS_VERSION/bin/phantomjs" /usr/local/bin/phantomjs
RUN ln -sf "/usr/local/share/$PHANTOM_JS_VERSION/bin/phantomjs" /usr/bin/phantomjs
RUN rm -rf "$PHANTOM_JS_VERSION.tar.bz2"

RUN mkdir /myapp
WORKDIR /myapp

COPY ./Gemfile /myapp/
COPY ./Gemfile.lock /myapp/

ENV RAILS_ENV test
ENV BUNDLE_PATH /root/.bundler

RUN yarn install

ARG QUERO_VOTAR_GIT_REVISION
VOLUME /root/.yarn-cache /root/.bundler
