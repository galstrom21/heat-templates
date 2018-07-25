#!/bin/bash
set -x

mkdir /var/consul
mkdir -p /etc/consul.d/server

# Create the config file
tee /etc/consul.d/server/config.json <<EOH
{
    "bootstrap_expect": 3,
    "server": true,
    "ui": true,
    "datacenter": "${dc_name}",
    "data_dir": "/var/consul",
    "log_level": "INFO",
    "enable_syslog": true,
    "start_join": ["${node1_ip}", "${node2_ip}", "${node3_ip}"]
}
EOH

# run consul in a screen session
screen -S consul -d -m consul agent -server -config-dir /etc/consul.d/server
