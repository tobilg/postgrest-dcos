FROM debian:jessie

ENV POSTGREST_VERSION 0.4.0.0

ENV DOCKERIZE_VERSION v0.3.0

ENV POSTGREST_PATH /opt/postgrest

RUN apt-get update && \
    apt-get install -y tar xz-utils wget libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    wget http://github.com/begriffs/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    tar --xz -xvf postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    mv postgrest /usr/local/bin/postgrest && \
    rm postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    mkdir -p $POSTGREST_PATH

ADD postgrest-entrypoint.sh $POSTGREST_PATH

RUN chmod +x $POSTGREST_PATH/postgrest-entrypoint.sh

ADD config.conf.template $POSTGREST_PATH

ENTRYPOINT ["/opt/postgrest/postgrest-entrypoint.sh"]
