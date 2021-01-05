#!/bin/bash

cd "$(dirname "$0")"

API_KEY="${API_KEY-"${1-""}"}"
PORT="${PORT-"${2-"4875"}"}"
NAME="${BAGETNAME-"baget-$PORT"}"
DATA_DIR="${DATA_DIR-"${3-"$(pwd)/baget-data"}"}"
UPSTREAM="${UPSTREAM-"${4-"https://api.nuget.org/v3/index.json"}"}"

mkdir -p "$DATA_DIR"
echo "${NAME} ${DATA_DIR}" > /dev/stderr 
echo "http://localhost:${PORT}/v3/index.json -> ${UPSTREAM}" > /dev/stderr 

exec podman run --rm -it --name "$NAME" \
  -p $PORT:4875 \
  --env-file baget.env \
  --env "ApiKey=$API_KEY" \
  --env "Mirror__PackageSource=$UPSTREAM" \
  -v "$(pwd)/appsettings.json:/app/appsettings.json:ro" \
  -v "${DATA_DIR}:/var/baget" \
  docker.io/loicsharma/baget
