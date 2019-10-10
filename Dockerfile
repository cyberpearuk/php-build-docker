FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zip \
	curl \
	git \
        php7.2 php7.2-xml php7.2-curl php7.2-zip php7.2-mbstring php7.2-dev php7.2-xdebug \
    && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get install -y php-dev
# Enable PHP AST
RUN git clone https://github.com/nikic/php-ast.git \
    && cd php-ast \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && rm -rf php-ast \
    && echo "extension=ast.so" > /etc/php/7.2/cli/conf.d/20-ast.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require \
        phpunit/phpunit \
        phpunit/php-code-coverage \
        squizlabs/php_codesniffer \
        overtrue/phplint \
        phan/phan

ENV PATH=$PATH:/root/.composer/vendor/bin PHAN_DISABLE_XDEBUG_WARN=1

CMD php

WORKDIR /workspace
