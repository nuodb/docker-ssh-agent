VERSION:=$(shell jq -r .version package.json)

#:help: help        | Displays the GNU makefile help
.PHONY: help
help: ; @sed -n 's/^#:help://p' Makefile

#:help: version     | Displays the current release version (see package.json)
.PHONY: version
version:
	@echo $(VERSION)

#:help: all         | Runs the `clean` and `release` targets
.PHONY: all
all: clean release

#:help: package     | Creates a `package` Docker image
.PHONY: package
package:
	docker build -f Dockerfile -t nuodb/ssh-agent:$(VERSION) .

#:help: publish     | Publishes a Docker image
.PHONY: publish
publish:
	docker push nuodb/ssh-agent:$(VERSION)

#:help: clean       | Cleans up any build artifacts
.PHONY: clean
clean:
	-docker rm $(docker ps --all -q -f status=exited)
	-docker rm $(docker ps --all -q -f status=created)
	-docker rmi -f nuodb/ssh-agent:$(VERSION)
	-docker image prune -f
	-rm -fr build node_modules