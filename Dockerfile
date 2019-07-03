FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zip \
	curl \
	git \
        php7.2 php7.2-xml php7.2-curl php7.2-zip php7.2-mbstring \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require codercms/nexus-composer-push dev-master \
    && composer global require phpunit/phpunit \
    && composer global require squizlabs/php_codesniffer \
    && composer global require overtrue/phplint

ENV PATH=$PATH:/root/.composer/vendor/bin

CMD php