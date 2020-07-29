#!/bin/sh

#Disabling firewall

sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Run on VM to bootstrap Puppet Master server

if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    sudo yum -y update &&\
    sudo yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm &&\
    sudo yum -y update &&\
    sudo yum -y install puppet-server

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.101   puppet-master.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.102   node-01.example.com  node01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.103   node-02.example.com  node02" | sudo tee --append /etc/hosts 2> /dev/null

    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet-master.example.com/' /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ncertname = puppet/' /etc/puppet/puppet.conf

    # symlink manifest from Vagrant synced folder location
    ln -s /vagrant/site.pp /etc/puppet/manifests/site.pp
    
fi

