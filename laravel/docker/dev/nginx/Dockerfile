FROM nginx:1.25.2-alpine

# install packages
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    bash \
    nginx \
    sudo \
    vim

## nginx
RUN rm -f /etc/nginx/conf.d/*
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/dev-laravel.menta.work.conf /etc/nginx/conf.d/dev-laravel.menta.work.conf

EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]