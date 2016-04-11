FROM resin/rpi-raspbian:jessie
MAINTAINER EasyChen <easychen@gmail.com>



# 先更新apt-get
RUN apt-get update && apt-get upgrade -y

# 安装unrar
RUN apt-get install unrar-free -y
RUN apt-get install p7zip-full -y
#RUN apt-get install p7zip-rar -y

# 安装PHP和Apache
RUN apt-get install apache2 -y
RUN apt-get install php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl php5-gd libxml2-dev -y


# 安装WebApp
RUN rm -Rf /var/www/html

RUN apt-get install git -y
RUN git clone https://github.com/easychen/KODExplorer.git  /var/www/html

# 安装aria2
RUN apt-get install aria2 -y

#RUN mkdir cldata
ADD aria2.conf /cldata/aria2.conf
COPY init.sh /cldata/init.sh
COPY init.php /cldata/init.php

#修正Raspberry Pi版本的apache2默认路径
RUN rm -rf /etc/apache2/sites-enabled/000-default
COPY 000-default /etc/apache2/sites-enabled/000-default

RUN chmod +x /cldata/init.sh

WORKDIR /var/www/html/comic
VOLUME /var/www/html/comic


EXPOSE 80 6800

RUN php /cldata/init.php
CMD /cldata/init.sh

