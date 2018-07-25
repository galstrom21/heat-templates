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

# Download and install consul
if ! wget https://releases.hashicorp.com/consul/${consul_ver}/consul_${consul_ver}_linux_amd64.zip; then
  rc="failure"
  reason="wget of the consul binary failed"
fi
unzip -d /usr/local/sbin consul_${consul_ver}_linux_amd64.zip

# Notify SwiftSignalHandle
# NOTE: (shep) For some reason the curl_cli is putting ''\'' around the endpoint url, causing it to fail
if [ $rc == "success" ]; then
  #${wc_notify} --data-binary '{"status": "SUCCESS", "data": "server1: consul has been installed!"}'
  curl -i -X PUT "${signal_endpoint}" --data-binary '{"status": "SUCCESS", "data": "consul has been installed!"}'
else
  #${wc_notify} --data-binary '{"status": "SUCCESS", "data": "server1: consul has been installed!"}'
  curl -i -X PUT "${signal_endpoint}" --data-binary '{"status": "FAILURE", "data": "${reason}"}'
fi
