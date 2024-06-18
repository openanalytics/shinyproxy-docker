# We use a builder image which fully prepares the /opt/shinyproxy directory.
# This directory can then be copied in *one step* to the final image.
# In addition we also need unzip during build but not during runtime.
FROM public.ecr.aws/docker/library/debian:buster as builder

# can be snapshots or releases
ARG NEXUS_REPOSITORY=releases
ARG JAR_LOCATION=https://nexus.openanalytics.eu/service/rest/v1/search/assets/download?sort=version&repository=$NEXUS_REPOSITORY&maven.groupId=eu.openanalytics&maven.artifactId=shinyproxy-operator&maven.extension=jar

RUN mkdir /opt/shinyproxy-operator/
ADD $JAR_LOCATION /opt/shinyproxy-operator/shinyproxy-operator.jar

RUN apt-get update -y && \
    apt-get install unzip && \
    unzip -p  /opt/shinyproxy-operator/shinyproxy-operator.jar META-INF/MANIFEST.MF | sed -En 's/Implementation-Version: (.*)\r/\1/gp' > /opt/shinyproxy-operator/VERSION

# FINAL IMAGE
FROM public.ecr.aws/docker/library/eclipse-temurin:17-jammy

LABEL maintainer="Tobia De Koninck <tdekoninck@openanalytics.eu>"
ENV SHINY_USER shinyproxy-operator

RUN useradd -c 'shinyproxy-operator user' -m -d /home/$SHINY_USER -s /bin/nologin $SHINY_USER
COPY --from=builder --chown=$SHINY_USER:$SHINY_USER /opt/shinyproxy-operator/ /opt/shinyproxy-operator/

WORKDIR /opt/shinyproxy-operator
USER $SHINY_USER

CMD ["java", "-jar", "/opt/shinyproxy-operator/shinyproxy-operator.jar"]
