#!/bin/bash 

yum install httpd
systemctl start httpd
systemctl enable httpd
systemctl status httpd