FROM razzek/base:java8

USER appuser
ARG WILDFLY_VERSION=9.0.2.Final
ARG WILDFLY_HASH=74689569d6e04402abb7d94921c558940725d8065dce21a2d7194fa354249bb6
RUN cd $HOME \
    && curl -s http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -o /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
    && echo "${WILDFLY_HASH} /tmp/wildfly-$WILDFLY_VERSION.tar.gz" | sha256sum -c \
    && tar zxf /tmp/wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly \
    && rm /tmp/wildfly-$WILDFLY_VERSION.tar.gz

ENV JBOSS_HOME /home/appuser/wildfly
EXPOSE 8080 9990

CMD ["/bin/tini", "--", "/home/appuser/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
