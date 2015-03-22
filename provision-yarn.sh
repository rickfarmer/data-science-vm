#!/usr/bin/env bash



echo "Installing Cloudera..."
# Config is at $ sudo vi /usr/lib/hadoop/bin/hadoop
# and sudo vi /usr/lib/hadoop/etc/hadoop
# sudo vi /etc/hadoop/conf/hadoop-env.sh

cd /vagrant

echo "Downloading Cloudera Installer RPM..."
curl -L -O "http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm"
sudo yum -y --nogpgcheck localinstall cloudera-cdh-5-0.x86_64.rpm

echo "Installing Hadoop YARN in pseudo-distributed mode..."
# Install Hadoop YARN in pseudo-distributed mode use,
sudo yum -y install hadoop-conf-pseudo

echo "Displaying Hadoop Configuration..."
tree /etc/hadoop/conf.pseudo

# Preserve environment variables when using sudo
sudo sh -c "echo \"Defaults env_keep+= "JAVA_HOME"\" >> /etc/sudoers"
sudo sh -c "echo \"JAVA_HOME=$JAVA_HOME\" >> /etc/environment"
sudo sh -c "echo \"export JAVA_HOME=$JAVA_HOME\" >> /etc/default/bigtop-utils"
sudo sh -c "echo \"export JAVA_HOME=$JAVA_HOME\" >> /etc/hadoop/conf/hadoop-env.sh"
# For MRv1 you may need to set JAVA_HOME in /usr/lib/hadoop-0.20/bin/hadoop

# May need to reboot after making changes to /etc/environments then test using
sudo env | grep JAVA_HOME

echo "Formatting namenode using user hdfs..."
sudo -u hdfs hdfs namenode -format

echo "Starting Hadoop Services.."
ls -la /etc/init.d/hadoop-*

# Start all Hadoop HDFS services
for x in `cd /etc/init.d; ls hadoop-hdfs-*`; do sudo service $x start; done

# Stop all Hadoop HDFS services
# for x in `cd /etc/init.d; ls hadoop-hdfs-*`; do sudo service $x stop; done

# Verify HDS services are started at http://localhost:50070/

echo "Creating the /tmp, /var and /var/log HDFS directories..."
sudo /usr/lib/hadoop/libexec/init-hdfs.sh

echo "Verifying the HDFS directory structure..."
sudo -u hdfs hadoop fs -ls -R /

echo "Starting YARN services..."
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-yarn-nodemanager start
sudo service hadoop-mapreduce-historyserver start


echo "Verifying HDFS daemon statuses..."
sudo -u hdfs hdfs dfsadmin -report


echo "Configuring Users for HDFS..."
sudo -u hdfs hadoop fs -mkdir /user/cloudera
sudo -u hdfs hadoop fs -chown cloudera /user/cloudera

sudo -u hdfs hadoop fs -mkdir /user/joe
sudo -u hdfs hadoop fs -chown joe /user/joe

sudo -u hdfs hadoop fs -mkdir /user/chuck
sudo -u hdfs hadoop fs -chown chuck /user/chuck

# Switch to another user $ su - cloudera
echo "Running example jobs... view at http://yarn:8088/cluster/apps"
su - cloudera
sudo -u cloudera hadoop fs -mkdir input
sudo -u cloudera hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar grep input output23 'dfs[a-z.]+'
hadoop fs -ls
hadoop fs -cat output23/part-r-00000 | head

# Alternate example job to run
# sudo -u cloudera hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 10 100


echo "SELinux must be disabled.  It is automatically disabled the first time the VM is provisioned."
echo "However, disabling it to take effect it requires a second boot.  i.e. vagrant reload"
echo "See the included README.md for more detail on how to run and work with this VM."

