FROM wyveo/nginx-php-fpm:php82
# ENV fpm_conf /etc/php/8.2/fpm/pool.d/www.conf
RUN apt-key adv --fetch-keys https://packages.sury.org/php/apt.gpg
RUN apt-key adv --fetch-keys https://nginx.org/keys/nginx_signing.key
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    ghostscript \
    vim \
    mariadb-client \
    && sed -i -e "s/max_execution_time\s*=\s*.*/max_execution_time = 600/g" ${php_conf} \
    && sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 2048M/g" ${php_conf} \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./app.conf /etc/nginx/conf.d/default.conf
COPY ./policy.xml /etc/ImageMagick-6/policy.xml

ENTRYPOINT ["/start.sh"]
