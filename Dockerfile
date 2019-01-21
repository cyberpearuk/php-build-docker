FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zip \
	curl \
	git \
        php7.2 php7.2-xml \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]