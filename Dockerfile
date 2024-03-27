FROM debian:bookworm
WORKDIR /sap_rd
RUN apt update && apt upgrade
RUN apt install curl -y
RUN apt install php php-cli php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-intl php-sqlite3 php-pgsql postgresql-client -y
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt install symfony-cli -y
RUN symfony server:ca:install
EXPOSE 8000/tcp

# docker build -t symfonydemo .
# docker run -it -p 8000:8000 -v .:/sap_rd symfonydemo
# 25/08/2021 /sap_rd/vendor/doctrine/dbal/src/Driver/PDO/PgSQL/Driver.php