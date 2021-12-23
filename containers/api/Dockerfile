FROM node:16

WORKDIR /usr/src/app

ENV ISSUER="https://ava-ai-prod.eu.auth0.com/"
ENV AUDIENCE="https://api-route.com"
ENV JWKS_URI="https://ava-ai-prod.eu.auth0.com/.well-known/jwks.json"

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

ENV PORT=3001

EXPOSE $PORT

CMD [ "node", "dist/main.js" ]
