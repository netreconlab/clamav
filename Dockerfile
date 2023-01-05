FROM node:lts-alpine

USER root
RUN apk add --no-cache clamav \
 clamav-libunrar;
# cron;

# Setup clamav
COPY conf /etc/clamav
RUN mkdir -p /var/log/clamav \
 && touch /var/log/clamav/freshclam.log \
 && touch /var/log/clamav/clamd.log \
 && mkdir -p /var/lib/clamav/ \
 && mkdir -p /run/clamav/ \
 && chown node /var/log/clamav \
    /var/log/clamav/freshclam.log \
    /var/log/clamav/clamd.log \
    /var/lib/clamav \
    /run/clamav \
 && chmod 600 /var/log/clamav/freshclam.log \
    /var/log/clamav/clamd.log \
 && echo '53 * * * *   /usr/bin/freshclam --quiet' > /etc/crontabs/root \
 && freshclam \
 && crond -l 2

USER node
EXPOSE 3310

CMD ["clamd"]
