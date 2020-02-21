#!/bin/bash

PORT=${NOMAD_PORT_port_server:-9999}

java -jar /home/app/wiremock-standalone-2.26.0.jar --enable-browser-proxying --root-dir /files-and-mappings-root --port "${PORT}" --verbose --record-mappings --local-response-templating
