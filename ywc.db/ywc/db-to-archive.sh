#!/bin/bash
echo 'ywc db creation (ywc)...'
mysqldump --comments=0 --skip-extended-insert -hlocalhost -uywc -pywcywc -C -B ywccore > /data/ywc/ywc.db/ywc/ywccore.sql
echo 'ywc db created (ywc)'