FROM node:21
WORKDIR /source
COPY ./source .

EXPOSE 3000

RUN npm install
RUN npm install -g nodemon
CMD ["nodemon", "-L", "app.js"]