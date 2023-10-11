FROM ubuntu:22.04

LABEL maintainer="jparks@jpconsulted.com"

ENV APT_CACHER_NG_CACHE_DIR=/acng/cache \
    APT_CACHER_NG_LOG_DIR=/acng/log \
    APT_CACHER_NG_USER=apt-cacher-ng

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y apt-cacher-ng* ca-certificates wget && \
    sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf && \
    sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf && \
    apt-get clean 

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

VOLUME [ "/acng/cache", "/acng/log" ]

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
