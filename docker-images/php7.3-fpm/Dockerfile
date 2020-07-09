FROM php:7.3-fpm-buster
RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  default-mysql-client \
  vim \
  libzip-dev \
  zip


RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  gd \
  intl \
  mbstring \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip

#mcrypt install
RUN pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt


# Install x debug
RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug


# Install magerun
RUN curl -o magerun https://files.magerun.net/n98-magerun.phar \
    && chmod +x ./magerun \
    && cp ./magerun /usr/local/bin/ \
    && rm ./magerun

# Set environment variables
ENV PATH=$PATH:/app/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
RUN composer config -g repositories.firegento composer https://packages.firegento.com

# Install modman
RUN curl -SL https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -o modman \
    && chmod +x ./modman \
&& mv ./modman /usr/local/bin/

#Install generate-modman
RUN curl -sS https://raw.githubusercontent.com/mhauri/generate-modman/master/generate-modman > generate-modman \
&& chmod +x ./generate-modman \
&& mv ./generate-modman /usr/local/bin/

#Install Oh-my-zsh
RUN git clone git://github.com/bwithem/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN echo 'alias magerun="magerun --skip-root-check"' >> ~/.zshrc
RUN echo 'alias magerun="magerun --skip-root-check"' >> ~/.bashrc

# Installs msmtp and sendmail
RUN apt-get update && apt-get install -q -y msmtp mailutils && rm -rf /var/lib/apt/lists/*


# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in msmtprc.
RUN echo "localhost openmage.local" >> /etc/hosts


EXPOSE 9001
