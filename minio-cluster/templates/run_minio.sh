#!/bin/bash
set -x

tee /tmp/run_minio.sh <<EOH
export MINIO_ACCESS_KEY=${minio_access_key}
export MINIO_SECRET_KEY=${minio_access_key}
minio server http://${node1_ip}/data http://${node2_ip}/data http://${node3_ip}/data http://${node4_ip}/data
EOH

chmod +x /tmp/run_minio.sh

# run minio in a screen session
screen -S minio -d -m /tmp/run_minio.sh
