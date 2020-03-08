#!/bin/bash
# File mounted as: /etc/sftp.d/bindmount.sh
# Just an example (make your own)

function bindmount() {
    if [ -d "$1" ]; then
        mkdir -p "$2"
    fi
    mount --bind $3 "$1" "$2"
}

# Remember permissions, you may have to fix them:
# chown -R :users /data/common

bindmount /data/admin-tools /home/admin/tools
bindmount /data/common /home/dave/common
bindmount /data/common /home/peter/common
bindmount /data/docs /home/peter/docs --read-only