#!/bin/bash
set -x
rc="success"

apt-get update
apt-get install -y unzip screen

# Setup SSH keys
cat << EOH |sudo tee /root/.ssh/id_rsa
${ssh_priv_key}
EOH
#echo ${ssh_priv_key} > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

echo ${ssh_pub_key} > /root/.ssh/id_rsa.pub
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# create directory for minio
mkdir /data

# Download and install minio
if ! wget ${minio_url} -P /usr/local/sbin; then
  rc="failure"
  reason="wget of the minio binary failed"
fi
chmod +x /usr/local/sbin/minio

# Download and install mc
if ! wget ${mc_url} -P /usr/local/sbin; then
  rc="failure"
  reason="wget of the mc binary failed"
fi
chmod +x /usr/local/sbin/mc

# Notify SwiftSignalHandle
# NOTE: (shep) For some reason the curl_cli is putting ''\'' around the endpoint url, causing it to fail
if [ $rc == "success" ]; then
  #${wc_notify} --data-binary '{"status": "SUCCESS", "data": "server1: consul has been installed!"}'
  curl -i -X PUT "${signal_endpoint}" --data-binary '{"status": "SUCCESS", "data": "minio has been installed on ${HOSTNAME}!"}'
else
  #${wc_notify} --data-binary '{"status": "SUCCESS", "data": "server1: consul has been installed!"}'
  curl -i -X PUT "${signal_endpoint}" --data-binary '{"status": "FAILURE", "data": "${reason}"}'
fi
