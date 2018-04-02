#!/bin/bash
waitforstartupmsg(){
    while [ ! "$(cat /myapp/shared/log/puma.stdout.log | grep 'puma startup')" ]; do
        sleep 1
    done
}

breakiferror(){
    err="$(cat /myapp/shared/log/puma.stderr.log | grep -v 'puma startup')"
    if [ "$err" ]; then
        echo there are errors on puma
        exit 1
    fi
}

waitforstartupmsg
sleep 2
breakiferror
exit 0
