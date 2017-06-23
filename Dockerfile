FROM heroku/heroku:16
MAINTAINER Luc Boissaye <luc@boissaye.fr>

# Node heroku
RUN export NODE_VERSION=5.10.0 && \
  curl -s --retry 3 -L https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz -o /tmp/node-v$NODE_VERSION-linux-x64.tar.gz && \
  tar -xzf /tmp/node-v$NODE_VERSION-linux-x64.tar.gz -C /tmp && \
  rsync -a /tmp/node-v$NODE_VERSION-linux-x64/ / && \
  rm -rf /tmp/node-v$NODE_VERSION-linux-x64*

RUN mkdir -p /var/app/
WORKDIR /var/app

# Node
COPY package.json /var/app
RUN npm install --unsafe-perm

EXPOSE 8080

CMD bash
