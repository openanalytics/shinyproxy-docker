# We use a builder image which fully prepares the /opt/shinyproxy directory.
# This directory can then be copied in *one step* to the final image.
# In addition we also need unzip during build but not during runtime.
FROM public.ecr.aws/docker/library/ubuntu:jammy AS builder

# can be snapshots or releases
ARG NEXUS_REPOSITORY=releases
ARG JAR_LOCATION=https://nexus.openanalytics.eu/service/rest/v1/search/assets/download?sort=version&repository=$NEXUS_REPOSITORY&maven.groupId=eu.openanalytics&maven.artifactId=shinyproxy-operator&maven.extension=jar

RUN mkdir /opt/shinyproxy-operator/
ADD --chmod=644 $JAR_LOCATION /opt/shinyproxy-operator/shinyproxy-operator.jar
RUN mkdir -p /opt/shinyproxy-operator/logs && chmod 777 /opt/shinyproxy-operator/logs

RUN apt-get update -y && \
    apt-get install -y unzip ca-certificates curl --no-install-recommends && \
    unzip -p  /opt/shinyproxy-operator/shinyproxy-operator.jar META-INF/MANIFEST.MF | sed -En 's/Implementation-Version: (.*)\r/\1/gp' > /opt/shinyproxy-operator/VERSION && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli --no-install-recommends

# FINAL IMAGE
FROM public.ecr.aws/docker/library/eclipse-temurin:21-jre-jammy

LABEL maintainer="Tobia De Koninck <tdekoninck@openanalytics.eu>"
ENV SHINY_USER=shinyproxy-operator

RUN useradd -c 'shinyproxy-operator user' -m -d /home/$SHINY_USER -s /sbin/nologin $SHINY_USER

RUN apt-get update -y && \
    apt-get install -y jq --no-install-recommends && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder --chown=$SHINY_USER:$SHINY_USER /opt/shinyproxy-operator/ /opt/shinyproxy-operator/
# Install only Docker cli binary to save space
COPY --from=builder /usr/bin/docker /usr/bin/docker
COPY install_plugins.sh install_plugins.sh

WORKDIR /opt/shinyproxy-operator
USER $SHINY_USER

CMD ["java", "-jar", "/opt/shinyproxy-operator/shinyproxy-operator.jar"]
