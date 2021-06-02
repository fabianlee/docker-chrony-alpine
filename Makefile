OWNER := fabianlee
PROJECT := docker-chrony-alpine
VERSION := 1.0.0
OPV := $(OWNER)/$(PROJECT):$(VERSION)
EXPOSEDPORT := 123:123

# linux capabilities
CAPS= --cap-add SYS_TIME --cap-add SYS_NICE
# --cap-add CAP_SYS_RESOURCE (not needed)

# chrony config file
VOL_FLAG= -v $(shell pwd)/chrony.conf:/etc/chrony/chrony.conf:ro

# you may need to change to "sudo docker" if not a member of 'docker' group
# add user to docker group: sudo usermod -aG docker $USER
DOCKERCMD := "docker"

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)


## builds docker image
docker-build:
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build -f Dockerfile -t $(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm $(OPV) | true

## runs container in foreground, testing a couple of override values
docker-run-fg: docker-ntp-port-clear
	$(DOCKERCMD) run -it --network host $(CAPS) -p $(EXPOSEDPORT) $(VOL_FLAG) --rm $(OPV)

## runs container in foreground, override entrypoint to use use shell
docker-debug:
	$(DOCKERCMD) run -it --rm --entrypoint "/bin/sh" $(OPV)

## run container in background
docker-run-bg: docker-ntp-port-clear
	$(DOCKERCMD) run -d --network host $(CAPS) -p $(EXPOSEDPORT) $(VOL_FLAG) --rm --name $(PROJECT) $(OPV)

docker-ntp-port-clear:
	! netstat -ulnp | grep -q ':123' || { echo -e "\n!!! ERROR ntp port 123 already bound locally. Try stopping the local ntp service"; exit 3; }

## get into console of container running in background
docker-cli-bg:
	$(DOCKERCMD) exec -it $(PROJECT) /bin/sh

## tails $(DOCKERCMD)logs
docker-logs:
	$(DOCKERCMD) logs -f $(PROJECT)

## stops container running in background
docker-stop:
	$(DOCKERCMD) stop $(PROJECT)

## pushes to $(DOCKERCMD)hub
docker-push:
	$(DOCKERCMD) push $(OPV)

test:
	./chrony_test.sh

## pushes to kubernetes cluster
k8s-apply:
	sed -e 's/1.0.0/$(VERSION)/' k8s-chrony-alpine.yaml | kubectl apply -f -

k8s-delete:
	kubectl delete -f k8s-chrony-alpine.yaml
