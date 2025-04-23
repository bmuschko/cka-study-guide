FROM node:latest
WORKDIR /usr/src/app
RUN npm install mysql2
COPY . .
EXPOSE 8080
CMD ["node", "web-app.js"]
