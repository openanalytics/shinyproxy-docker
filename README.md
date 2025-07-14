# ShinyProxy Docker files

This repository contains the Dockerfiles of the official Docker images of the
ShinyProxy project. This allows you to inspect how our images are build and to
build your own image. However, note that in most cases there is no need to build
your own images. 

## ShinyProxy

The Dockerfile for ShinyProxy can be found in the
[ShinyProxy directory](ShinyProxy/Dockerfile). The same Dockerfile is used for building
development, snapshot and production images.

### Locally building a development release

This section describes how to build a Dockerfile of ShinyProxy using a local JAR
file of ShinyProxy.

1. build ContainerProxy + ShinyProxy

    ```bash
    git clone -b develop https://github.com/openanalytics/containerproxy/ ContainerProxy
    git clone -b develop https://github.com/openanalytics/shinyproxy/ ShinyProxy
    pushd ContainerProxy
    mvn package install  -DskipTests
    popd
    pushd ShinyProxy
    mvn -U clean package install  -DskipTests
    popd
    ```

2. copy the JAR to the location of this repository

    ```bash
    git clone https://github.com/openanalytics/shinyproxy-docker/ docker
    cd docker/ShinyProxy
    cp ../../ShinyProxy/target/shinyproxy*.jar .
    ```

3. build the docker image

    ```bash
    docker build -t shinyproxy-dev --build-arg JAR_LOCATION=shinyproxy-*.jar .
    ```

### Building latest snapshot version

You can also build a Docker image of ShinyProxy using the official snapshot
builds of ShinyProxy. In that case Docker downloads the required JAR file from
our Nexus server. The version information contained in the JAR file always ends
with `-SNAPSHOT`. Official builds of this image are available at 
[Docker Hub](https://hub.docker.com/r/openanalytics/shinyproxy-snapshot).

```bash
git clone https://github.com/openanalytics/shinyproxy-docker/ docker
cd docker/ShinyProxy
docker build --build-arg NEXUS_REPOSITORY=snapshots -t shinyproxy-snapshot .
```

### Building latest release version

Finally, you can build a Docker image of ShinyProxy using the official release
versions of ShinyProxy. Similar to the snapshot version, Docker downloads the
required JAR file from our Nexus server. The version information contained in
the JAR file does not have a suffix, indicating a release build. Official builds
of this image are available at 
[Docker Hub](https://hub.docker.com/r/openanalytics/shinyproxy).

```bash
git clone https://github.com/openanalytics/shinyproxy-docker/ docker
cd docker/ShinyProxy
docker build --build-arg NEXUS_REPOSITORY=releases -t shinyproxy .
```

The JAR file will be downloaded from our Nexus server.

## ShinyProxy Operator

The Dockerfile for ShinyProxy Operator can be found in the [Operator
directory](Operator/Dockerfile). This Docker image is very similar to that of
ShinyProxy itself. Again, the same Dockerfile is used for building development, snapshot
and production images. 

### Locally building a development release

This section describes how to build a Dockerfile of ShinyProxy using a local JAR
file of the Operator.

1. build the Operator

    ```bash
    git clone -b develop https://github.com/openanalytics/shinyproxy-operator/ shinyproxy-operator
    cd shinyproxy-operator
    mvn package install -DskipTests
    ```

2. copy the JAR to the location of this repository

    ```bash
    git clone https://github.com/openanalytics/shinyproxy-docker/ docker
    cd docker/Operator
    cp ../../shinyproxy-operator/target/shinyproxy-operator-jar-with-dependencies.jar .
    ```

3. build the docker image

    ```bash
    docker build -t shinyproxy-operator-dev --build-arg JAR_LOCATION=shinyproxy-operator-jar-with-dependencies.jar .
    ```

### Building latest snapshot version

You can also build a Docker image of the operator using the official snapshot
builds of the operator. In that case Docker downloads the required JAR file from
our Nexus server. The version information contained in the JAR file always ends
with `-SNAPSHOT`. Official builds of this image are available at 
[Docker Hub](https://hub.docker.com/r/openanalytics/shinyproxy-operator-snapshot).

```bash
git clone https://github.com/openanalytics/shinyproxy-docker/ docker
cd docker/Operator
docker build --build-arg NEXUS_REPOSITORY=snapshots -t shinyproxy-operator-snapshot .
```

### Building latest release version

Finally, you can build a Docker image of operator using the official release
versions of ShinyProxy. Similar to the snapshot version, Docker downloads the
required JAR file from our Nexus server. The version information contained in
the JAR file does not have a suffix, indicating a release build. Official builds
of this image are available at
[Docker Hub](https://hub.docker.com/r/openanalytics/shinyproxy-operator).

```bash
git clone https://github.com/openanalytics/shinyproxy-docker/ docker
cd docker/Operator
docker build --build-arg NEXUS_REPOSITORY=releases -t shinyproxy-operator .
```

The JAR file will be downloaded from our Nexus server.

## Using the Docker Image
 
- [ShinyProxy](https://github.com/openanalytics/shinyproxy-config-examples/tree/master/02-containerized-docker-engine)
- [ShinyProxy Operator](https://shinyproxy.io/documentation/shinyproxy-operator/features/)

**(c) Copyright Open Analytics NV, 2020-2025 - Apache License 2.0**
