# Summary
Docker image that runs chrony daemon NTP server on port 123/udp

Image is based on alpine and is ~ 8Mb

blog: https://fabianlee.org/2021/06/02/docker-building-an-ntp-server-image-with-alpine-and-chrony/
dockerhub: https://hub.docker.com/r/fabianlee/docker-chrony-alpine

# Prerequisites
* docker
* sudo apt-get install make

# Makefile targets
* docker-build (builds image)
* docker-run-fg (runs container in foreground, ctrl-C to exit)
* docker-run-bg (runs container in background)
* k8s-apply (applies deployment to kubernetes cluster)
* k8s-delete (removes deployment on kubernetes cluster)
* test (runs ntpdate test)
