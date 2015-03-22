#!/usr/bin/env bash

. /vagrant/.env

# JAVA_HOME must be set something like jdk1.7.0_75 
# **NOT** the Chef cleaned version of /usr/lib/jvm/java (it is a bug in cloudera)
# e.g. JAVA_HOME=/usr/lib/jvm/jdk1.7.0_75
echo $JAVA_HOME


echo "Disabling SELinux..."
sudo sh -c "echo \"SELINUX=disabled\" > /etc/sysconfig/selinux"
sudo sh -c "echo \"SELINUXTYPE=targeted\" >> /etc/sysconfig/selinux"
echo 0 >/selinux/enforce

echo "Configuring Network..."
sudo sh -c "echo \"$VM_IP	$VM_HOSTNAME\" >> /etc/hosts"

echo "Creating and Configuring Users..."
sudo sh -c "echo \"vagrant ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

sudo groupadd hadoopusers --gid 505
sudo sh -c "echo \"hadoopusers ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

useradd -u 506 -g 505 -m -s /bin/bash cloudera
echo "cloudera" | passwd cloudera --stdin > /dev/null
sudo sh -c "echo \"cloudera ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

useradd -u 507 -g 505 -m -s /bin/bash joe
echo "joe" | passwd joe --stdin > /dev/null
sudo sh -c "echo \"joe ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

useradd -u 508 -g 505 -m -s /bin/bash chuck
echo "chuck" | passwd chuck --stdin > /dev/null
sudo sh -c "echo \"chuck ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

echo "Configuring the user .bash_profile"
sudo cat /vagrant/bash_profile_append.txt > ~/.bash_profile
sudo cat /vagrant/bash_profile_append.txt > /home/cloudera/.bash_profile
sudo cat /vagrant/bash_profile_append.txt > /home/joe/.bash_profile
sudo cat /vagrant/bash_profile_append.txt > /home/chuck/.bash_profile


echo "Installing System Tools..."
su -c 'yum update'
sudo yum install -y ntp ntpdate ntp-doc
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
/etc/init.d/ntpd start
sudo yum install -y tree
sudo yum install -y git
sudo yum install -y curl #>/dev/null 2>&1
sudo yum install -y unzip #>/dev/null 2>&1
sudo yum install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 #>/dev/null 2>&1
sudo yum update -y #>/dev/null 2>&1
