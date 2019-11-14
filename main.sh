#!/usr/bin/env bash

# uncomment to debug
set -x
set -e
set -o pipefail

if [ -f '.env' ]; then source '.env'; fi

grab_page() {
  # https://superuser.com/questions/590099/can-i-make-curl-fail-with-an-exitcode-different-than-0-if-the-http-status-code-i
  # $1 -- url
  # $2 -- file to save to
  STATUSCODE=$(curl --silent --output $2 --write-out "%{http_code}"  -H "Cookie: autologin=${autologin};" $1)
  if test $STATUSCODE -ne 200; then
    echo "curl failed"
    exit 1
  fi
}

do_section() {
  # $1 section name
  # $2 state number
  echo "Doing $1"
  grab_page "https://i.doit.im/api/tasks/${1}" data/${1}.json
  jq -f ./tasks.jq --arg state $2 data/${1}.json > data/${1}2.json
  curl  -H 'Content-Type: application/json' "https://focus.nirvanahq.com/api/?api=json&authtoken=${authtoken}&appid=n2desktop&appversion=1525880921" --data-binary "@./data/${1}2.json" -v
}

mkdir -p data

grab_page https://i.doit.im/api/resources_init data/resources.json

jq -f ./contexts.jq data/resources.json > data/contexts.json
curl  -H 'Content-Type: application/json' "https://focus.nirvanahq.com/api/?api=json&authtoken=${authtoken}&appid=n2desktop&appversion=1525880921" --data-binary "@./data/contexts.json" -v

jq -f ./projects.jq data/resources.json > data/projects.json
curl  -H 'Content-Type: application/json' "https://focus.nirvanahq.com/api/?api=json&authtoken=${authtoken}&appid=n2desktop&appversion=1525880921" --data-binary "@./data/projects.json" -v

# (0 = Inbox, 1 = Next, 2 = Waiting, 3 = Scheduled, 4 = Someday, 5 = Later, 6 = Trashed, 7 = Logged, 8 = Deleted, 9 = Recurring, 11 = Active project )
do_section "inbox" 0
do_section "next" 1
do_section "waiting" 2
do_section "today" 3
do_section "tomorrow" 3
do_section "scheduled" 3
do_section "someday" 4
