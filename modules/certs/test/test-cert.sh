#!/bin/bash

# exit on any errors
set -eE

TEST_ONLY=0
SETUP_ONLY=0
# seconds to wait on k8s/alarms/etc
MAX_WAIT=240
# seconds to pause between checking k8s/alarms/etc
PAUSE_TIME=2

RED='\033[0;31m'
NC='\033[0m' # No Color


on_exit () {
  set +e
  echo -n -e "${RED}"
  echo "============================================================"
  echo "Test script failed."
  echo "============================================================"
  echo "Attempting cleanup..."
  echo -e "${NC}"
  exit 1
}
trap on_exit ERR
trap do_cleanup EXIT

# PATH=${PATH}:~/work/shoreline/cli/go/bin/
# PATH=${PATH}:~/work/shoreline/cli/go/bin CLI=`command -v oplang_cli`


############################################################
# Utility functions

pre_error() {
  echo -n -e "${RED}"
  echo "============================================================"
  echo "ERROR: $1"
  echo "============================================================"
  echo -e "${NC}"
  exit 1
}


do_timeout() {
  echo -n -e "${RED}"
  echo "============================================================"
  echo "ERROR: Timed out waiting for $1"
  echo "============================================================"
  echo "Attempting cleanup..."
  echo -e "${NC}"
  exit 2
}

check_command() {
  command -v $1 > /dev/null || pre_error "missing command $1"
}

check_env() {
  env | grep -e "^$1=" ||  pre_error "missing env variable $1"
}

get_event_counts() {
  count=`echo "events |  name =~ 'cicerts' | count" | ${CLI}`
  if [ -z "$count" ]; then
    echo 0
  else
  echo "${count}" | grep "group_all"
  fi
}

check_webserver_file() {
  echo "pod | app='certs-test' | limit=1 | \`ls /\`" | ${CLI} | grep "main.py"
}

check_start_webserver_file() {
  echo "pod | app='certs-test' | limit=1 | \`ls /\`" | ${CLI} | grep "start-webserver.sh"
}

check_refresh_cert_file() {
  echo "pod | app='certs-test' | limit=1 | \`ls /\`" | ${CLI} | grep "refresh-cert.sh"
}

############################################################
# Pre-flight validation

check_command kubectl
check_command oplang_cli

check_env SHORELINE_URL
check_env SHORELINE_TOKEN
check_env CLUSTER

CLI=`command -v oplang_cli`


############################################################
# setup

do_setup() {
  echo "Setting up kubernetes objects"
  kubectl delete pod certs-test || true && kubectl delete svc certs-demo || true
  kubectl apply -f certs_test_k8s.yaml
  kubectl wait po certs-test --for=condition=Ready --timeout 60s && sleep 5
  echo "Setting up terraform objects"
  terraform init
  terraform apply -target=shoreline_file.cert_check_start_webserver_file -target shoreline_file.cert_check_refresh_cert_file -target shoreline_file.cert_check_webserver_file --auto-approve

  # dynamically wait for the webserver file to propagate
  echo "waiting for the webserver file to propagate ..."
  used=0
  while ! check_webserver_file; do
    echo "  waiting..."
    sleep ${PAUSE_TIME}
    # timeout after maximum wait and fail
    used=$(( ${used} + ${PAUSE_TIME} ))
    if [ ${used} -gt ${MAX_WAIT} ]; then
      do_timeout "start webserver file propagation"
    fi
  done
  echo "webserver file is propagated"

  # dynamically wait for the start webserver file to propagate
  echo "waiting for the start webserver file to propagate ..."
  used=0
  while ! check_start_webserver_file; do
    echo "  waiting..."
    sleep ${PAUSE_TIME}
    # timeout after maximum wait and fail
    used=$(( ${used} + ${PAUSE_TIME} ))
    if [ ${used} -gt ${MAX_WAIT} ]; then
      do_timeout "start webserver file propagation"
    fi
  done
  echo "start webserver file is propagated"

  # start web server
  kubectl exec -it certs-test -- bash /start-webserver.sh 100

  # dynamically wait for the refresh cert file to propagate
  echo "waiting for the refresh cert file to propagate ..."
  used=0
  while ! check_refresh_cert_file; do
    echo "  waiting..."
    sleep ${PAUSE_TIME}
    # timeout after maximum wait and fail
    used=$(( ${used} + ${PAUSE_TIME} ))
    if [ ${used} -gt ${MAX_WAIT} ]; then
      do_timeout "refresh cert file propagation"
    fi
  done
  echo "refresh cert file is propagated"
  kubectl exec -it certs-test -- chmod +x /refresh-cert.sh

  terraform apply --auto-approve
}

############################################################
# cleanup

do_cleanup_terraform() {
  echo "Cleaning up terraform objects"
  terraform destroy --auto-approve
}

do_cleanup_kubernetes() {
  echo "Cleaning up kubernetes objects"
  kubectl delete -f certs_test_k8s.yaml || true
}

do_cleanup() {
  if [ "${TEST_ONLY}" == "0" ] && [ "${SETUP_ONLY}" == "0" ]; then
    do_cleanup_terraform
    do_cleanup_kubernetes
  fi
}

############################################################
# actual tests

run_tests() {
  # count alarms before we started
  pre_fired=`get_event_counts | cut -d '|' -f 7 | tr -d '[:space:]'`
  pre_cleared=`get_event_counts | cut -d '|' -f 8 | tr -d '[:space:]'`
  kubectl exec -it certs-test -- /refresh-cert.sh renew 10
  echo "waiting for file alarm to fire ..."

  # verify that the alarm fired:
  post_fired=`get_event_counts | cut -d '|' -f 7 | tr -d '[:space:]'`
  used=0
  while [ "${post_fired}" == "${pre_fired}" ]; do
    echo "waiting..."
    sleep ${PAUSE_TIME}
    post_fired=`get_event_counts | cut -d '|' -f 7 | tr -d '[:space:]'`
    # timeout after maximum wait and fail
    used=$(( ${used} + ${PAUSE_TIME} ))
    if [ ${used} -gt ${MAX_WAIT} ]; then
      do_timeout "alarm to fire"
    fi
  done
  echo "alarm is fired"

 # verify that the alarm cleared:
 echo "waiting for alarm to clear ..."
 post_cleared=`get_event_counts | cut -d '|' -f 8 | tr -d '[:space:]'`
 used=0
 while [ "${post_cleared}" == "${pre_cleared}" ]; do
   echo "waiting..."
   sleep ${PAUSE_TIME}
   post_cleared=`get_event_counts | cut -d '|' -f 8 | tr -d '[:space:]'`
   # timeout after maximum wait and fail
   used=$(( ${used} + ${PAUSE_TIME} ))
   if [ ${used} -gt ${MAX_WAIT} ]; then
     do_timeout "failed waiting alarm to clear"
   fi
 done
 echo "test is done"
}

do_all() {
  do_setup
  run_tests
  echo "============================================================"
  echo "test is successful"
  echo "============================================================"
}

case $1 in
            setup) SETUP_ONLY=1; do_setup ;;
          cleanup) exit 0 ;;
       test-debug) set -x; do_all ;;
        test-only) TEST_ONLY=1; run_tests ;;
  test-only-debug) TEST_ONLY=1; set -x; run_tests ;;
                *) do_all ;;
esac
