#!/bin/bash

#設定ファイルを移動
sudo mv apache2.conf /etc/apache2/apache2.conf
sudo mv 000-default.conf /etc/apache2/sites-available/000-default.conf
sudo mv 001-normal.conf /etc/apache2/sites-available/
sudo mv 002-trap.conf /etc/apache2/sites-available/

sudo systemctl restart apache2

# English exit message
echo "*****************************"
echo "*Script execution completed.*"
echo "*****************************"