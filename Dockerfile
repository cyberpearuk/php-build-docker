# -----------------------------------------------------------------------------
# Base image & PHP version
# -----------------------------------------------------------------------------
FROM ubuntu:22.04

ARG PHPVERSION=8.3
ENV DEBIAN_FRONTEND=noninteractive \
    PHAN_DISABLE_XDEBUG_WARN=1 \
    PATH="$PATH:/root/.config/composer/vendor/bin:/root/.composer/vendor/bin"

WORKDIR /workspace

# -----------------------------------------------------------------------------
# 1) Install prerequisites & import Ondřej PPA key
# -----------------------------------------------------------------------------
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       gnupg2 \
       dirmngr \
       lsb-release \
       zip \
       git \
       subversion \
       build-essential \
  \
  # fetch and install PPA signing key
  && curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xB8DC7E53946656EFBCE4C1DD71DAEAAB4AD4CAB6" \
       | gpg --dearmor -o /etc/apt/trusted.gpg.d/ondrej-php.gpg \
  \
  # add the PPA to sources.list
  && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -sc) main" \
       > /etc/apt/sources.list.d/ondrej-php.list

# -----------------------------------------------------------------------------
# 2) Install PHP + extensions
# -----------------------------------------------------------------------------
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       php${PHPVERSION}-cli \
       php${PHPVERSION}-xml \
       php${PHPVERSION}-curl \
       php${PHPVERSION}-zip \
       php${PHPVERSION}-mbstring \
       php${PHPVERSION}-dev \
       php${PHPVERSION}-xdebug \
       php${PHPVERSION}-mysql \
       libmagickwand-dev \
       php${PHPVERSION}-imagick \
  \
  # clean up APT lists and PPA metadata
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/apt/sources.list.d/ondrej-php.list \
  && apt-get purge -y gnupg2 dirmngr lsb-release

# -----------------------------------------------------------------------------
# 3) Build & enable nikic/php-ast
# -----------------------------------------------------------------------------
RUN git clone https://github.com/nikic/php-ast.git /tmp/php-ast \
  && cd /tmp/php-ast \
  && phpize \
  && ./configure \
  && make -j"$(nproc)" install \
  && echo "extension=ast.so" \
       > /etc/php/${PHPVERSION}/cli/conf.d/20-ast.ini \
  && rm -rf /tmp/php-ast

# -----------------------------------------------------------------------------
# 4) Install Composer & global PHP tools
# -----------------------------------------------------------------------------
RUN curl -sS https://getcomposer.org/installer \
      | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer self-update --2 \
  && composer global require --no-interaction \
       phpunit/phpunit \
       phpunit/php-code-coverage \
       squizlabs/php_codesniffer \
       overtrue/phplint \
       phan/phan

# -----------------------------------------------------------------------------
# Default command
# -----------------------------------------------------------------------------
CMD ["php"]
