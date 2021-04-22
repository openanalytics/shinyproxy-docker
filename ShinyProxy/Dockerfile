# We use a builder image which fully prepares the /opt/shinyproxy directory.
# This directory can then be copied in *one step* to the final image.
# In addition we also need unzip during build but not during runtime.
FROM debian:buster as builder

# can be snapshots or releases
ARG NEXUS_REPOSITORY=releases
ARG JAR_LOCATION=https://nexus.openanalytics.eu/service/rest/v1/search/assets/download?sort=version&repository=$NEXUS_REPOSITORY&maven.groupId=eu.openanalytics&maven.artifactId=shinyproxy&maven.extension=jar

RUN mkdir /opt/shinyproxy
ADD $JAR_LOCATION /opt/shinyproxy/shinyproxy.jar

RUN apt-get update -y && \
    apt-get install unzip && \
    unzip -p /opt/shinyproxy/shinyproxy.jar META-INF/MANIFEST.MF | sed -En 's/Implementation-Version: (.*)\r/\1/gp' > /opt/shinyproxy/VERSION

COPY application.yml /opt/shinyproxy/application.yml

# FINAL IMAGE
FROM openjdk:11-jre-slim-buster

LABEL maintainer="Tobia De Koninck <tdekoninck@openanalytics.eu>"
ENV SHINY_USER shinyproxy

RUN useradd -c 'shinyproxy user' -m -d /home/$SHINY_USER -s /bin/nologin $SHINY_USER
COPY --from=builder --chown=$SHINY_USER:$SHINY_USER /opt/shinyproxy/ /opt/shinyproxy/

WORKDIR /opt/shinyproxy
USER $SHINY_USER

# Start ShinyProxy with some extra parameters for faster startup (https://spring.io/blog/2018/11/08/spring-boot-in-a-container#tweaks)
CMD ["java", "-noverify",  "-jar", "/opt/shinyproxy/shinyproxy.jar", "--spring.jmx.enabled=false", "--spring.config.location=/opt/shinyproxy/application.yml"]
