#!/usr/bin/env bash

echo "Checking whether the Loki driver docker plugin is installed"
if ! plugins=$(docker plugin list --format=json); then
  echo "Checking plugins failed - not installing plugin"
  exit 1
fi
while read -r plugin ; do
  name=$(echo "$plugin" | jq -r .Name)
  if [[ $name == loki* ]] ; then
    echo "Loki plugin already installed"
    exit 0
  fi
done <<< "$plugins"
echo "Installing loki plugin"

if [ -z "$SPO_DOCKER_LOKI_PLUGIN_IMAGE" ]; then
  arch=`uname -m`
  if [ "$arch" == "x86_64" ]; then
    image="grafana/loki-docker-driver:3.4.4-amd64"
  elif [ "$arch" == "aarch64" ]; then
    image="grafana/loki-docker-driver:3.4.4-arm64"
  else
    echo "Unknown arch: $arch"
  fi
else
  image=$SPO_DOCKER_LOKI_PLUGIN_IMAGE
fi

echo "Installing $image"

if ! docker plugin install "$image" --alias loki --grant-all-permissions; then
  echo "Installing plugin failed"
  exit 1
fi
