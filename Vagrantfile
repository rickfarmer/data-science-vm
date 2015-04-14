# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# Use the .env file to configure environment variables 
# for use by vagrant (e.g. ENV['VM_NAME']) and sourced in 
# provisioning scripts (e.g. $VM_NAME)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Install required plugins using:
  # vagrant plugin install vagrant-env
  # vagrant plugin install vagrant-omnibus
  config.env.enable 
  config.omnibus.chef_version = :latest 
  config.vm.box = "chef/centos-6.5"
  config.vm.box_url = "http://atlas.hashicorp.com/chef/centos-6.5"
  config.vm.hostname = ENV['VM_HOSTNAME']
  config.vm.network "private_network", ip: ENV['VM_IP']
  
	# Boot with a GUI so you can see the screen. (Default is headless)
  #config.vm.boot_mode = :gui
  #config.vm.provider :virtualbox do |v|
  #  v.name = ENV['VM_NAME']
  #  v.gui = true
  #end
  
  config.vm.provider :vmware_fusion do |v, override|
    v.gui = true
    v.name = ENV['VM_NAME'] + " " + ENV['HADOOP_TYPE']
    v.vmx["displayName"] = ENV['VM_NAME']
    v.vmx["annotation"] = ENV['VM_DESC'] + ENV['HADOOP_TYPE']
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "1"
  end
  
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 7180, host: 7180, auto_correct: true # Cloudera Manager Admin Console
  config.vm.network :forwarded_port, guest: 7182, host: 7182, auto_correct: true # Cloudera Manager Server
  config.vm.network :forwarded_port, guest: 9000, host: 9000, auto_correct: true # Cloudera Agent
  config.vm.network :forwarded_port, guest: 9001, host: 9001, auto_correct: true # Cloudera Agent
  config.vm.network :forwarded_port, guest: 7432, host: 7432, auto_correct: true # Cluster Embedded Database for Hive and Activity Monitor
  config.vm.network :forwarded_port, guest: 9083, host: 9083, auto_correct: true # Hive Metastore Server Port
  config.vm.network :forwarded_port, guest: 8020, host: 8029, auto_correct: true # HBase, hdfs://localhost:8020/hbase
  config.vm.network :forwarded_port, guest: 50070, host: 50070, auto_correct: true # HDFS Status Page
  config.vm.network :forwarded_port, guest: 8088, host: 8088, auto_correct: true # Hadoop Status Page
  config.vm.network :forwarded_port, guest: 19888, host: 19888, auto_correct: true # Hadoop Status History Page


  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles. 
  config.vm.provision :chef_solo do |chef|

    chef.cookbooks_path = "cookbooks"

    chef.json = {
      :java => {
        :install_flavor => 'oracle',
        :jdk_version => 7,
        :oracle => {
          :accept_oracle_download_terms => true
        }
      },
      :mysql => {
        :server_root_password => 'password',
        :server_debian_password => 'password',
        :server_repl_password => 'password'
      }
    }


    chef.add_recipe "yum"
    chef.add_recipe "vim"
    chef.add_recipe "build-essential"
    chef.add_recipe "java"

#    chef.run_list = [
#      'recipe[yum::default]',
#      'recipe[vim::default]',
#      'recipe[build-essential::default]',
#      'recipe[java::default]'
#    ]

  end

  if ENV['HADOOP_TYPE'] == 'mrv1'

    config.vm.provision "shell", inline: "echo Installing Cloudera Hadoop MRv1..."
    config.vm.provision "shell", path: "provision.sh"
    config.vm.provision "shell", path: "provision-mrv1.sh"
    config.vm.provision "shell", inline: "echo Installation complete"
  
  else

    config.vm.provision "shell", inline: "echo Installing Cloudera Hadoop YARN MRv2..."
    config.vm.provision "shell", path: "provision.sh"
    config.vm.provision "shell", path: "provision-yarn.sh"
    config.vm.provision "shell", inline: "echo Installation complete"
  
  end  

  if ENV['MAHOUT'] == 'true'

    config.vm.provision "shell", inline: "echo Installing Mahout..."
    config.vm.provision "shell", path: "provision-mahout.sh"
    config.vm.provision "shell", inline: "echo Installation complete"

  end

  
end
