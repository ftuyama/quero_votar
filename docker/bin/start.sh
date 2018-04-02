#!/bin/bash
mkdir -p /myapp/shared/log
if [[ ! -L /myapp/public ]]; then
    rm -rf /dkdata/public
    mv /myapp/public /dkdata/public
    ln -s /dkdata/public /myapp/public
fi
cd /myapp
rake assets:precompile
export SOCKETFILE=/dkdata/my.sock
cron
puma
