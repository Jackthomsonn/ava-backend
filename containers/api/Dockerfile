FROM node:16

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . ./

RUN npm run build

ENV PORT=3001

EXPOSE $PORT

CMD [ "npm", "run", "start:prod" ]
