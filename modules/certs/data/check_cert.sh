#!/bin/bash

MAX_STATUS_CHECKS=10             # max number of times to check the status
STATUS_CHECK_WAIT_SEC=1          # amount of time in seconds to wait between the status checks
declare -i EXIT_STATUS_CODE=0    # exit status of the script
declare -i status_count=0        # status count for the while loop

# check the command if it's successful or not
while [ "$status_count" -ne $MAX_STATUS_CHECKS ]
do
  index=0
  status_count=$((status_count+1))
  stderr=$(echo | $OPENSSL_BINARY_LOCATION s_client -servername $URL -connect $URL:$PORT 2>/dev/null | openssl x509 -checkend $EXPIRE_SECONDS 2>&1 >/dev/null)
  if [[ $? == 0 ]] && [[ ${#stderr} == 0 ]]; then
    break
  elif [[ $? != 0 ]] && [[ ${#stderr} == 0 ]]; then
    EXIT_STATUS_CODE=10
    break
  fi
  sleep $STATUS_CHECK_WAIT_SEC
  # check if the status checks reached max value, if so print out the failure reason
  if [ "$status_count" -eq $MAX_STATUS_CHECKS ]; then
      echo "number of attempts: ${status_count}/${MAX_STATUS_CHECKS}"
      echo "----------------------------------"
      echo "max status checks reached for the action, couldn't detect the cert of the URL: $URL after $status_count tries"
      echo "error message is:"
      echo $stderr
      # set the exit code of the script in the case o partial failure
      EXIT_STATUS_CODE=1
      break
  fi
  echo "number of attempts: ${status_count}/${MAX_STATUS_CHECKS}"
done

exit $EXIT_STATUS_CODE