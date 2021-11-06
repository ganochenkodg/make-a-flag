FROM node:14-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY ./package*.json /app/
RUN npm install --silent
COPY . /app
RUN npm run build

FROM nginxinc/nginx-unprivileged:1.20
COPY --from=build /app/public /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
