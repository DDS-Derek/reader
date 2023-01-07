ARG READER_TAG=2.7.3

FROM hectorqin/reader:openj9-${READER_TAG} AS CHOOSE

FROM ibm-semeru-runtimes:open-8u332-b09-jre

RUN apt-get update -y && apt-get install ca-certificates tini tzdata gosu bash -y; \
    update-ca-certificates; \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENV READER_JAVA_VERSION=openj9

ENTRYPOINT ["/usr/bin/tini", "/entrypoint.sh"]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]