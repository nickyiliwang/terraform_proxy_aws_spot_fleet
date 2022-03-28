#!/bin/bash
while [ ! -f /etc/tinyproxy/tinyproxy.conf ]; do sleep 1; done
sudo echo Allow ${access_ip} >> /etc/tinyproxy/tinyproxy.conf
sudo /etc/init.d/tinyproxy restart