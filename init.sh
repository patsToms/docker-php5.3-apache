#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

if [ -z "$MYSQL_PORT_3306_TCP" ]; then
	echo >&2 'error: missing MYSQL_PORT_3306_TCP environment variable'
	echo >&2 '  Did you forget to --link some_mysql_container:mysql ?'
	exit 1
fi

chown -R www-data:www-data /var/www