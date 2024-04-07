/*
const express = require('express');
const fs = require('fs');
const path = require('path');
*/
import express from 'express';
import path from 'path';

import {fileURLToPath} from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const router = express.Router();

//static 미들웨어를 통해 상대주소 반환 --> ES6 에선 안 되네..
router.use(express.static(path.join(__dirname, '..', 'public')));
//파일명을 지정하지 않았으므로 index.html이 자동으로 전송됨
//fs.sendFile을 사용할 필요 없음

export default router;