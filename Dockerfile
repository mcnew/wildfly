FROM razzek/base:java8

COPY module.xml $JBOSS_HOME/modules/org/mariadb/jdbc/main/

ARG WILDFLY_VERSION=9.0.2.Final
ARG WILDFLY_HASH=74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6
ARG MARIADB_HASH=006dd7b51c4031795a8c24c90f9a9bd896d65626c0c9c242b3e1aab3aeefa10e
ENV JBOSS_HOME=/opt/wildfly/
RUN curl -fsSL http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && echo "${WILDFLY_HASH} /tmp/wildfly-$WILDFLY_VERSION.tar.gz" | sha256sum -c \
 && curl -fsSL https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/1.5.2/mariadb-java-client-1.5.2.jar > /home/appuser/wildfly/modules/org/mariadb/jdbc/main/mariadb-java-client.jar \
 && echo "${MARIADB_HASH} /home/appuser/wildfly/modules/org/mariadb/jdbc/main/mariadb-java-client.jar" | sha256sum -c \
 && cd /opt \
 && tar zxf /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && mv /opt/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
 && mkdir /home/appuser/wildfly \
 && mv $JBOSS_HOME/standalone /home/appuser/wildfly/ \
 && chown -R appuser:appuser /home/appuser/wildfly

USER appuser
EXPOSE 8080 9990
WORKDIR /home/appuser/

CMD ["/bin/tini", "--", "/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-Djboss.server.base.dir=/home/appuser/wildfly/standalone" ]
