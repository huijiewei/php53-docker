FROM ubuntu:precise
MAINTAINER Tom Hill <tom@greensheep.io>

# Add libraries directory
ADD ./lib /home/lib
ADD ./assets/sources.list /etc/apt/sources.list

##########################
## INSTALL DEPENDENCIES ##
##########################

# Install packages
RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)

RUN apt-get -y install php5 php5-fpm php5-gd \
    php5-sqlite php-pear php5-mysql \
    php5-mcrypt
###############
## CONFIGURE ##
###############

# PHP config files
ADD ./conf/php/php.ini /etc/php5/fpm/php.ini

RUN sed -i '/daemonize /c \
daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c \
listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

EXPOSE 9000
ENTRYPOINT ["php5-fpm"]
