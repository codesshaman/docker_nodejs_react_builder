FROM node:16.17.1-alpine3.15 as builder

ARG FOLDER

WORKDIR /app

COPY source .

RUN yarn add @craco/craco yarn add craco-less

RUN yarn build

FROM nginx:1.23.3-alpine-slim as production

COPY --from=builder /app/build /usr/share/nginx/html

COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]