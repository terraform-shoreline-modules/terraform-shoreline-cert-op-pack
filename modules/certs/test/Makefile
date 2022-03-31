CLUSTER?=test12
SHORE_URL?=https://test.us.api.shoreline-${CLUSTER}.io
SHORE_TOKEN?=$(echo grep -B1 ${CLUSTER} ~/.ops_auth.yaml | grep "Token:" | tail -n 1 | cut -d':' -f2 | tr -d ' ')

test:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) PATH=${PATH}:~/work/shoreline/cli/go/bin bash ./test-cert.sh

init:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) terraform init

install:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) terraform apply --auto-approve

install-files:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) terraform apply -target=shoreline_file.cert_check_start_webserver_file -target shoreline_file.cert_check_refresh_cert_file -target shoreline_file.cert_check_webserver_file --auto-approve

remove:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) terraform destroy --auto-approve

setup:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) ./test-cert.sh setup

cleanup:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) ./test-cert.sh cleanup

test-only:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) ./test-cert.sh test-only

test-debug:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) ./test-cert.sh test-debug

test-only-debug:
	SHORELINE_URL=$(SHORE_URL) SHORELINE_TOKEN=$(SHORE_TOKEN) CLUSTER=$(CLUSTER) ./test-cert.sh test-only-debug


distclean:
	rm -rf terraform.tfstate terraform.tfstate.backup

.PHONY: distclean
