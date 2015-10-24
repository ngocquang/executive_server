FROM ubuntu:14.04
MAINTAINER Quang Dinh <ngocquangbb@gmail.com>

#VOLUME ["/home/www:/var/www"]
#ENV TERM xterm

RUN rm -rf /var/lib/apt/lists/* -vf
RUN sudo apt-get clean

RUN sudo apt-get autoremove
RUN sudo apt-get dist-upgrade 

RUN sudo apt-get update
RUN sudo apt-get install -y \
      apache2 \
      php5 \
      php5-cli \
      php5-dev \
      libapache2-mod-php5 \
      php5-gd \
      curl \
      cron \
      php5-curl \
      php5-json \
      php5-ldap \
      php5-mysql \
      php5-pgsql \
      supervisor \
      gcc git libpcre3-dev

#RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git /usr/local/src/cphalcon
#RUN cd /usr/local/src/cphalcon/build && ./install ;\
#    echo "extension=phalcon.so" > /etc/php5/mods-available/phalcon.ini ;\
#    php5enmod phalcon

COPY apache_default /etc/apache2/sites-available/000-default.conf
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/supervisord.conf
#ADD crontab /etc/crontab

# Copy site into place.
ADD www /var/www

#RUN echo "* * * * * curl http://localhost/getcommand >/dev/null 2>&1\n* * * * curl http://localhost/getcommand >/dev/null 2>&1\n* * * * * curl http://localhost/getcommand >/dev/null 2>&1" >> mycron
RUN echo "* * * * * curl http://localhost/getcommand >/dev/null 2>&1" >> mycron
RUN echo "* * * * * curl http://localhost/getcommand >/dev/null 2>&1" >> mycron
RUN echo "* * * * * curl http://localhost/getcommand >/dev/null 2>&1" >> mycron
RUN tail mycron
RUN crontab mycron
RUN rm mycron


EXPOSE 80
#CMD ["/usr/local/bin/run"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
