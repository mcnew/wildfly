FROM razzek/base:java8

ARG APP_NAME
ARG CONFIG_HASH=1d5a45e3247a0633f98f8b5d31eac73beafabfa4fe9bedaa59727ea0eec2f286

COPY standalone.patch /tmp/

RUN patch /home/appuser/wildfly/standalone/configuration/standalone.xml /tmp/standalone.patch \
 && echo "${CONFIG_HASH} /home/appuser/wildfly/standalone/configuration/standalone.xml" | sha256sum -c \
 && rm /tmp/standalone.patch

ONBUILD COPY target/APP_NAME.war $JBOSS_HOME/standalone/deployments/
