FROM ubuntu:12.04

RUN apt-get update && apt-get install -y \
                apache2 \
                php5 \
                php5-mysql
RUN a2enmod rewrite
RUN rm -rf /var/www/html

VOLUME /var/www

COPY apache-vhost.conf /etc/apache2/sites-available/000-default
COPY init.sh /init.sh

ENTRYPOINT ["/init.sh"]

CMD ["apache2", "-DFOREGROUND"]