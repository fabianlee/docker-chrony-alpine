# Summary
Docker image that runs chrony daemon NTP server on port 123/udp

Image is based on alpine and is ~ 8Mb

https://hub.docker.com/r/fabianlee/docker-chrony-alpine

# Prerequisites
* docker
* make utility (sudo apt-get install make)

# Makefile targets
* docker-build (builds image)
* docker-run-fg (runs container in foreground, ctrl-C to exit)
* docker-run-bg (runs container in background)
* k8s-apply (applies deployment to kubernetes cluster)
* k8s-delete (removes deployment on kubernetes cluster)
* test (runs ntpdate test)
