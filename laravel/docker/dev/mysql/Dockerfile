FROM --platform=linux/x86_64 mysql:8.0.27

ENV LC_ALL ja_JP.UTF-8
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
RUN apt-get update
RUN apt-get install -y --no-install-recommends\
    locales \
    vim \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    /var/lib/apt/lists/*

RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8

RUN touch /var/log/mysqld.log \
    && chown mysql:adm /var/log/mysqld.log

COPY ./my.cnf /etc/mysql/