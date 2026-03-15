FROM alpine:3.22 AS tool-source
RUN apk add --no-cache shadow su-exec libbsd

FROM n8nio/n8n:latest

USER root

COPY --from=tool-source /usr/sbin/groupmod /usr/sbin/groupmod
COPY --from=tool-source /usr/sbin/usermod /usr/sbin/usermod
COPY --from=tool-source /usr/sbin/groupadd /usr/sbin/groupadd
COPY --from=tool-source /usr/sbin/useradd /usr/sbin/useradd
COPY --from=tool-source /usr/bin/getent /usr/bin/getent
COPY --from=tool-source /usr/lib/libbsd.so.0 /usr/lib/libbsd.so.0
COPY --from=tool-source /usr/lib/libmd.so.0 /usr/lib/libmd.so.0
COPY --from=tool-source /sbin/su-exec /sbin/su-exec

RUN [ -f /etc/passwd ] && deluser node || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["n8n"]