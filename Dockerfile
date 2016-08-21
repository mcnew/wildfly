FROM razzek/java:jdk-8-alpine

ARG WILDFLY_VERSION=9.0.2.Final
ARG WILDFLY_HASH=74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6
ENV JBOSS_HOME=/opt/wildfly JBOSS_BASE_DIR=/home/appuser/wildfly
RUN apk add --no-cache augeas unzip libarchive-tools \
 && wget -q http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -O /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && echo "${WILDFLY_HASH}  /tmp/wildfly-$WILDFLY_VERSION.tar.gz" | sha256sum -c \
 && mkdir /opt \
 && cd /opt \
 && tar zxf /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && mv /opt/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
 && mkdir $JBOSS_BASE_DIR \
 && mv $JBOSS_HOME/standalone $JBOSS_BASE_DIR \
 && chown -R appuser:appuser $JBOSS_BASE_DIR

USER appuser
WORKDIR $JBOSS_BASE_DIR

EXPOSE 8080 9990
CMD ["/usr/bin/tini", "--", "/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-Djboss.server.base.dir=/home/appuser/wildfly/standalone" ]
