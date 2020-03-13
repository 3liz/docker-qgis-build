#!/usr/bin/env bash

# Run docker interactively in the current directory
export USERID=0 GROUPID=0
exec qgis-build-env.sh ${1:-"armv7hf-buster"}

