# Data Science VM

##Need to install the following Gems
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-env

## Users
root/vagrant
joe/joe
chuck/chuck
cloudera/cloudera


## Hive Embedded DB
PostgresSQL
Host, e63:7432
DB name, hive
Username, hive
Password, 8xlpmpA6NE

# Hue
http://e63:8888/
hdfs/hdfs

# Test the Cluster
sudo -u hdfs hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 10 100