#!/bin/bash

export base_dir=/home/vagrant/local.dev

export DBPASSWD=root

if [ ! -f ~/.deploy_run ]
    then
    echo "Add Vagrant user to the sudoers group..."
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    echo "Set MySQL root password..."
    echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections

    echo "Installing packages..."
    curl -sL https://deb.nodesource.com/setup_4.x | bash -
    apt-get -q -y install nodejs software-properties-common vim git curl
    apt-get -q -y install mysql-server nginx
    apt-get -q -y install php5-cli php5-fpm php5-mysql php5-curl php5-mcrypt

    echo "Installing composer..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    echo "Running composer installation..."
    cd $base_dir/code/
    composer install

    echo "Installing bower and components..."
    npm i -g bower
    cd $base_dir/
    bower i

    echo "Setting permissions..."
    usermod -G vagrant www-data
    usermod -G www-data vagrant

    echo "Customizing nginx..."
    service nginx stop
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
    cp $base_dir/util/vg_nginx.conf /etc/nginx/nginx.conf
    service nginx start

    echo "Setting up env..."
    cd $base_dir/code
    cp example.env .env

    echo "Create DB..."
    mysql -uroot -p$DBPASSWD -e "CREATE DATABASE local CHARACTER SET utf8 COLLATE utf8_general_ci;"
    cd $base_dir/code
    php $base_dir/code/vendor/bin/phinx migrate

    touch ~/.deploy_run
fi
