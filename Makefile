SHELL := /bin/bash

#
# default var
#
DOCKER_BUILD_ARGS= # --no-cache
DOCKER_BUILD_NAME=eidas
DOCKER_DEFAULT_PLATFORM=linux/amd64
EIDAS_NODE_VERSION=2.7
export
#
# eidas-node with wildfy
#
build-wildfly: build-eidas-node-wildfly build-eidas-node-mock-wildfly
# eidas-node only
build-eidas-node-wildfly:
	docker build ${DOCKER_BUILD_ARGS} -t ${DOCKER_BUILD_NAME}-node:wildfly-latest docker/wildfly
# full eidas-node with mock
build-eidas-node-mock-wildfly:
	docker build ${DOCKER_BUILD_ARGS} -t ${DOCKER_BUILD_NAME}-mock:wildfly-latest --target mock docker/wildfly

run-wildfly: run-eidas-node-mock-wildfly
down-wildfly: down-eidas-node-mock-wildfly
run-eidas-node-mock-wildfly:
	docker-compose -f docker-compose-wildfly.yaml up ${DOCKER_BUILD_NAME}-mock
down-eidas-node-mock-wildfly:
	docker-compose -f docker-compose-wildfly.yaml down ${DOCKER_BUILD_NAME}-mock
#
# eidas-node with tomcat
#
build-tomcat: build-eidas-node-tomcat build-eidas-node-mock-tomcat
# eidas-node only
build-eidas-node-tomcat:
	docker build ${DOCKER_BUILD_ARGS} -t ${DOCKER_BUILD_NAME}-node-${EIDAS_NODE_VERSION}:tomcat-latest --target eidas-node-$([ "${EIDAS_NODE_VERSION}" \>= 2.7 ] && echo split || echo monolithic) docker/tomcat
# full eidas-node with mock
build-eidas-mock-tomcat:
	docker build ${DOCKER_BUILD_ARGS} -t ${DOCKER_BUILD_NAME}-mock-${EIDAS_NODE_VERSION}:tomcat-latest --target eidas-mock-$([ "${EIDAS_NODE_VERSION}" \>= 2.7 ] && echo split || echo monolithic) docker/tomcat

run-tomcat-mock:
	docker-compose -f docker-compose-tomcat-mock.yaml up ${DOCKER_BUILD_NAME}-mock
down-tomcat-mock:
	docker-compose -f docker-compose-tomcat-mock.yaml down ${DOCKER_BUILD_NAME}-mock
run-tomcat:
	docker-compose -f docker-compose-tomcat.yaml up ${DOCKER_BUILD_NAME}-node
down-tomcat:
	docker-compose -f docker-compose-tomcat.yaml down ${DOCKER_BUILD_NAME}-node

#
# dummy test
#
test-localhost-eidas-node:
	curl -L localhost:8080/EidasNode/ServiceMetadata
	curl -L localhost:8080/EidasNode/ConnectorMetadata
	curl -L localhost:8080/SP/
	curl -L localhost:8080/IdP/
	curl -L localhost:8080/SpecificProxyService
	curl -L localhost:8080/SpecificConnector
