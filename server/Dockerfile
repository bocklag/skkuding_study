FROM node:21
WORKDIR /source
COPY ../source/ .

RUN npm install
RUN npm install -g nodemon
CMD ["nodemon", "-L", "app.js"]