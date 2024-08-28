#!/bin/sh
chmod -R +x -- /docker/guacamole/config/init
rm -rf /docker/guacamole/config/data/ /docker/guacamole/config/drive/ /docker/guacamole/config/record/
