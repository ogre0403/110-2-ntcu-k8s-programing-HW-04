kind_name ?= kind
IMG := controller:latest


prepare:
	make docker-build IMG=controller:latest
	kind load docker-image $(IMG) --name $(kind_name)

run: prepare
	make deploy
	@bash .validate/helper.sh

all: run
	 @bash .validate/validate-rule2.sh
	 @bash .validate/validate-rule3.sh
	 @bash .validate/validate-rule4.sh



