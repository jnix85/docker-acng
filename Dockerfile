FROM ubuntu:22.04

LABEL maintainer="jparks@jpconsulted.com"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y apt-cacher-ng* ca-certificates wget && \
    apt-get clean 

COPY acng.conf /etc/apt-cacher-ng/acng.conf
COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3142/tcp

HEALTHCHECK --interval=10s --timeout=2s --retries=3 \
    CMD wget -q -t1 -O /dev/null  http://localhost:3142/acng-report.html || exit 1

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/apt-cacher-ng"]
