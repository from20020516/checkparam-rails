DOCKER := docker run --rm -it -v $(PWD):/var/www --workdir /var/www --entrypoint /bin/bash checkparam-rails_devcontainer_checkparam

init:
	docker build -f .devcontainer/Dockerfile -t checkparam-rails_devcontainer_checkparam .
	npm --prefix .aws-cdk/ install

build:
	$(DOCKER) -c 'bundle config set --local path 'vendor/bundle' && bundle install && rails assets:non_digested'
	npm --prefix .aws-cdk/ run cdk deploy
