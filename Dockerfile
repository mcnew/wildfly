FROM razzek/base:java8

ARG WILDFLY_VERSION=9.0.2.Final
ARG WILDFLY_HASH=74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6
ENV JBOSS_HOME=/opt/wildfly/
RUN curl -s http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && echo "${WILDFLY_HASH} /tmp/wildfly-$WILDFLY_VERSION.tar.gz" | sha256sum -c \
 && cd /opt \
 && tar zxf /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
 && mv /opt/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
 && mkdir /home/appuser/wildfly \
 && mv $JBOSS_HOME/standalone /home/appuser/wildfly/ \
 && chown -R appuser:appuser /home/appuser/wildfly

USER appuser
EXPOSE 8080 9990

CMD ["/bin/tini", "--", "/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-Djboss.server.base.dir=/home/appuser/wildfly/standalone" ]
