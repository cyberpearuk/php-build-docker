FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
	zip \
	curl \
	git \
        php7.2 php7.2-xml php7.2-curl  php7.2-zip \
    && rm -rf /var/lib/apt/lists/*

ADD phplint.sh /usr/bin/phplint

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add nexus publisher
RUN composer global require codercms/nexus-composer-push dev-master

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]