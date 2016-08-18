FROM razzek/base:java8

USER appuser
ARG WILDFLY_VERSION=9.0.2.Final
RUN cd $HOME \
    && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz | tar zx \
    && mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

ENV JBOSS_HOME /home/appuser/wildfly
EXPOSE 8080 9990

CMD ["/bin/tini", "--", "/home/appuser/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
