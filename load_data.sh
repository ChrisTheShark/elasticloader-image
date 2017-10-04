#!/bin/bash

echo "Loading index to Elasticsearch."

status=$(curl --write-out %{http_code} --silent --output /dev/null \
         -u elastic:changeme -X PUT http://elasticsearch:9200/vehicles \
         -d @/opt/index.json --header "Content-Type: application/json")

# Allowing 400 as the index may have already been added. Remove
# if use case requires fresh creation each run.
if [ $status -eq 200 -o $status -eq 400 ]
then
  echo "Successfully created index, loading test documents."
  status=$(curl --write-out %{http_code} --silent --output /dev/null \
           -u elastic:changeme -vX PUT http://elasticsearch:9200/vehicles/_bulk \
           --data-binary @/opt/data.json --header "Content-Type: application/json")
  if [ $status -eq 200 ]
  then
    echo "Data load complete. Exiting gracefully."
    exit 0
  else
    echo "Index created, data load failed!"
    exit 1
  fi
else
  echo "Could not create index! Received status code $status." >&2
  exit 1
fi
