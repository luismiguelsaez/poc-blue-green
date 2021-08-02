FROM alpine:3.12

LABEL Description="Simple and light nginx server to be used as router for B/G deployment"
LABEL Author="Luis Miguel Sáez Martín"

RUN apk add --no-cache nginx
RUN mkdir /run/nginx

RUN addgroup -g 1000 router \
    && adduser -u 1000 -h /etc/nginx -s /sbin/nologin -D -G router router

ADD nginx.conf /etc/nginx
RUN chown -R 1000.1000 /etc/nginx /var/log/nginx /run/nginx /var/lib/nginx

USER router

EXPOSE 8080

ENTRYPOINT [ "nginx","-c","/etc/nginx/nginx.conf" ]
