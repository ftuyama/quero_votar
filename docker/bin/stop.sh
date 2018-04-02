#!/bin/bash
killit(){
    kill $(cat /myapp/shared/puma.pid)
}

waituntildead(){
    while [ "$(ps -ef | grep puma | grep -v grep)" ]; do
        echo ta vivo
        sleep 1
    done
}

killit
waituntildead
echo morreu
