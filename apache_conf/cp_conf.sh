#!/bin/bash

#設定ファイルを移動
sudo cp apache2.conf /etc/apache2/apache2.conf
sudo cp 000-default.conf /etc/apache2/sites-available/000-default.conf
sudo cp 001-normal.conf /etc/apache2/sites-available/
sudo cp 002-trap.conf /etc/apache2/sites-available/

sudo systemctl restart apache2

# English exit message
echo "*****************************"
echo "*Script execution completed.*"
echo "*****************************"