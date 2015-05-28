#!/bin/bash

echo "Installing Maven..."
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version

echo "Installing Mahout..."
sudo yum -y install mahout

echo "Installing Spark..."
sudo yum -y install hadoop-client
sudo yum -y install spark-core spark-master spark-worker spark-history-server spark-python

echo "Installing MongoDB..."
sudo mkdir data
sudo mkdir data/db
sudo cat /vagrant/mongodb_append.txt > /etc/yum.repos.d/mongodb.repo
sudo yum -y install mongo-10gen mongo-10gen-server
sudo chkconfig mongod on
sudo service mongod start
