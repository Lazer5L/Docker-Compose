#!/bin/bash
sudo chmod -R +x -- /docker/guacamole/config/init
sudo rm -r -f /docker/guacamole/config/data/ /docker/guacamole/config/drive/ /docker/guacamole/config/record/
