/*
const express = require('express');
const fs = require('fs');
const path = require('path');
const os = require('os');
*/
import express from 'express';
import fs from 'fs';
import os from 'os';
import path from 'path';

const router = express.Router();
router.use(express.json());

import {fileURLToPath} from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

router.post('/login', (req, res) => {
    fs.readFile(path.join(__dirname, '..', 'users.json'), (readErr, data) => {
        if (readErr) {
            res.status(500).send();
        } else {
            const users = JSON.parse(data);
            const {username, password} = req.body;
            const valid = users.some(user => user.username === username && user.password === password);
            if (valid) {
                res.status(200).send('로그인 성공');
            } else {
                res.status(401).send();
            }
        }
    });
});

router.post('/signup', (req, res) => {
    const {username, password, email} = req.body;

    //기존 사용자 정보와 비교
    fs.readFile(path.join(__dirname, '..', 'users.json'), (readErr, data) => {
        let users = [];
        //파일이 있긴 함
        if (!readErr) {
            try {
                users = JSON.parse(data);
            } catch (parseErr) {
                return res.status(500).send();
            }
            //some() --> 조건 충족하는 밸류가 하나라도 있으면 True
            const isDuplicate = (users.some(user => user.username === username));
            if (isDuplicate) {
                return res.status(400).send();
            }
        }
        users.push({username, password, email});

        fs.writeFile('users.json', JSON.stringify(users), (writeErr) => {
            if (writeErr) {
                return res.status(500).send();
            }
            res.status(201).send();
        });
    });
});

router.get('/os', (req, res) => {
    const osInfo = {
        type: os.type(),
        hostname: os.hostname(),
        cpu_num: os.cpus().length,
        total_mem: os.totalmem()/(1024*1024) + 'MB'
    };

    res.json(osInfo);
});

export default router;