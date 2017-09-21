#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

wget https://xdebug.org/files/xdebug-2.5.5.tgz
tar xvzf xdebug-2.5.5.tgz
cd xdebug-2.5.5
phpize
./configure
make
sudo cp modules/xdebug.so /usr/lib/php/20160303/
cd /etc/php/7.1/fpm/conf.d/
sudo service php7.1-fpm restart

if [ ! -f /etc/php/7.1/mods-available/xdebug.ini ]; then
    echo "xdebug.ini not found"
else
    sudo truncate -s 0 /etc/php/7.1/mods-available/xdebug.ini
    sudo sh -c 'echo "zend_extension=xdebug.so" >> /etc/php/7.1/mods-available/xdebug.ini'
    sudo sh -c 'echo "xdebug.remote_enable=1" >> /etc/php/7.1/mods-available/xdebug.ini'
    sudo sh -c 'echo "xdebug.remote_connect_back=1" >> /etc/php/7.1/mods-available/xdebug.ini'
    sudo sh -c 'echo "xdebug.remote_port=9000" >> /etc/php/7.1/mods-available/xdebug.ini'
    sudo sh -c 'echo "xdebug.max_nesting_level=250" >> /etc/php/7.1/mods-available/xdebug.ini'
    sudo sh -c 'echo "xdebug.remote_autostart = 1" >> /etc/php/7.1/mods-available/xdebug.ini'
fi

if [ ! -f "/etc/php/7.1/cli/conf.d/20-xdebug.ini" ]; then 
    sudo ln -s /etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/cli/conf.d/20-xdebug.ini
else
    echo '20-xdebug.ini symlink exists'
fi
sudo service php7.1-fpm restart
php -v
rm -rf ~/xdebug-2.5.5
rm ~/xdebug-2.5.5.tgz
rm ~/package.xml

