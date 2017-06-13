FROM ubuntu:trusty

WORKDIR /app

COPY package.json yarn.lock ./

RUN apt-get update && apt-get install -y curl python-software-properties
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get update && apt-get install -y nodejs
RUN npm set registry https://npm.jackmac.party
RUN npm i -g yarn
RUN ln -s $(which nodejs) /usr/local/bin/node
RUN yarn install

ADD . .

RUN chmod +x /app/entrypoint.sh

CMD /app/entrypoint.sh
# RUN node installer/index.js BUILD TIME IS NOT RUN TIME IDIOT
