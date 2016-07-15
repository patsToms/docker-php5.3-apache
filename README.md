## Build
```
docker build -t toms/php:5.3.10-apache .
```

## Usage with Compose
```
version: '2'
services:
  db:
    image: mysql:5.7
    volumes:
      - "./.data/db:/var/lib/mysql"
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: db
      MYSQL_USER: root
      MYSQL_PASSWORD: root

  web:
    depends_on:
      - db
    image: toms/php:5.3.10-apache
    links:
      - db
    ports:
      - "8000:80"
    restart: always
```