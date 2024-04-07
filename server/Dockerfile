FROM node:21
WORKDIR /source
COPY . .

RUN npm install
RUN npm install -g nodemon
CMD ["nodemon", "-L", "app.js"]