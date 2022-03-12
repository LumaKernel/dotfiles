#!/bin/bash

sudo ufw allow ssh
sudo ufw allow 41641/udp
sudo ufw allow 3478/udp
sudo ufw allow from 10.0.0.0/8
sudo ufw allow from 172.16.0.0/12
sudo ufw allow from 192.168.0.0/16
sudo ufw allow from 100.0.0.0/8

sudo ufw status

echo "[info] sudo ufw disable && sudo ufw enable"
