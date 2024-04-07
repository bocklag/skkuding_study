/*
const express = require('express');
const fs = require('fs');
const os = require('os');
const path = require('path');
*/
import express from 'express';

const app = express();
const PORT = 3000;

app.set('port', process.env.PORT || 3000);

/*
const indexRouter = require('./routes/indexRouter');
const apiRouter = require('./routes/apiRouter')
*/
import indexRouter from './routes/indexRouter.js';
import apiRouter from './routes/apiRouter.js';

app.use('/', indexRouter);
app.use('/api', apiRouter);

app.use(express.json());


app.use((req, res, next) => {
    res.status(404).send('404 Not Found');
    });

app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).send(err.message);
});

app.listen(app.get('port'), () => {
    console.log(app.get('port'), '번 포트에서 대기 중');
});
