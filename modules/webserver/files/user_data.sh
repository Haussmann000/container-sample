#!/bin/bash
echo "installing apache"
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "hello terraform" > /var/www/html/index.html