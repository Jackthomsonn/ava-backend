FROM node:16

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

ENV PORT=3000

EXPOSE $PORT

CMD [ "node", "dist/main.js" ]
