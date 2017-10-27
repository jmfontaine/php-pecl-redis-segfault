.DEFAULT_GOAL := help
.SILENT:

DOCKER_IMAGE = "php-pecl-redis-segfault"
PROJECT_DIR = "$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))"

help: ## Display usage
	grep -E -h '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## Run example script against the given php-pecl-redis package and PHP versions (e.g., make run PHP=5.6 PKG=3.1.2)
	$(eval PHP_VERSION := $(subst .,,$(PHP)))
	$(eval PHPREDIS_VERSION := $(PHPREDIS))
	$(eval TAG := "$(PHP_VERSION)-$(PHPREDIS_VERSION)")
	echo "Building Docker image"
	echo
	docker build . --build-arg php_version=$(PHP_VERSION) --build-arg phpredis_version=$(PHPREDIS_VERSION) --tag $(DOCKER_IMAGE):$(TAG)
	echo
	echo "Running example script"
	echo
	docker run --rm --mount type=bind,source="$(PROJECT_DIR)",target=/app $(DOCKER_IMAGE):$(TAG) php /app/example.php
	echo
