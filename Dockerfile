FROM java:8-jdk

ENV SCALA_VERSION 2.12.2
ENV SCALA_TARBALL http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb

WORKDIR /tmp

RUN set -e \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes curl \
    && curl -sSL http://apt.typesafe.com/repo-deb-build-0002.deb -o repo-deb.deb \
    && dpkg -i repo-deb.deb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes libjansi-java \
    && curl -sSL $SCALA_TARBALL -o scala.deb \
    && dpkg -i scala.deb \
    && curl -sSL https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.13.8.jar -o elasticmq-server-0.13.8.jar \
    && rm -f *.deb \
    && apt-get remove -y --auto-remove curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["java", "-jar", "elasticmq-server-0.13.8.jar"]

