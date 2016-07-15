FROM ubuntu:12.04

RUN apt-get update && apt-get install -y \
		apache2 \
		libapache2-mod-php5 \
		php5-mysql
RUN a2enmod rewrite

# copy a few things from apache's init script that it requires to be setup
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
# and then a few more from $APACHE_CONFDIR/envvars itself
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# make CustomLog (access log) go to stdout instead of files
#  and ErrorLog to stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
	s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
	s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' '{}' ';'

RUN rm -rf /var/www
VOLUME /var/www
WORKDIR /var/www

COPY apache-vhost.conf /etc/apache2/sites-available/000-default
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/init.sh"]
EXPOSE 80
CMD ["apache2", "-DFOREGROUND"]