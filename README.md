# Terraform proxy fleet

1. template to provision spot fleet, betting at as low as possible
2. Start from 1 > 10 > 100
3. Will use an pre-baked AMI with tiny-proxy pkg installed, maybe Debian (buster) / Ubuntu
4. VPC with IGW in one subnet for now
5. Outputs all the public ipv4 addresses once all instance are running
6. deploy to us-east-1
7. Security group will only allow my IP to SSH and connect to the EC2 instances

## TinyProxy
1. sudo vim /etc/tinyproxy/tinyproxy.conf
2. Allow my-ip/32
3. sudo /etc/init.d/tinyproxy restart
4. open SG port 8888 to only me

## Guides
1. https://dev.to/viralsangani/be-anonymous-create-your-own-proxy-server-with-aws-ec2-2k63
2. 