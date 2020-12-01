FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG PHPVERSION=7.4

RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get install -y \
	zip \
	curl \
	git \
	subversion \
        php${PHPVERSION} php${PHPVERSION}-xml php${PHPVERSION}-curl php${PHPVERSION}-zip php${PHPVERSION}-mbstring php${PHPVERSION}-dev php${PHPVERSION}-xdebug \
        libmagickwand-dev php-imagick \
    && add-apt-repository --remove -y ppa:ondrej/php \
    && apt-get remove -y software-properties-common \
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
    && echo "extension=ast.so" > /etc/php/${PHPVERSION}/cli/conf.d/20-ast.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer self-update 1.10.16 \
    && composer global require \
        phpunit/phpunit \
        phpunit/php-code-coverage \
        squizlabs/php_codesniffer \
        overtrue/phplint \
        phan/phan

ENV PATH=$PATH:/root/.config/composer/vendor/bin PHAN_DISABLE_XDEBUG_WARN=1

CMD php

WORKDIR /workspace
