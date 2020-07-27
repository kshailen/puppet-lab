#!/bin/sh


#Disabling firewall

sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Run on VM to bootstrap Puppet Agent nodes

if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Agent is already installed. Moving on..."
else
    sudo yum -y update &&\
    sudo yum -y install http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm &&\
    sudo yum -y update &&\
    sudo yum -y install puppet
fi


    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.101   puppet-master.example.com  puppet" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.102   node-01.example.com  node01" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.33.103   node-02.example.com  node02" | sudo tee --append /etc/hosts 2> /dev/null

    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo -e "[agent] \nserver=puppet" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null

    sudo puppet agent --enable
    sudo systemctl start puppet
    systemctl enable puppet
