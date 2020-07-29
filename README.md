## Vagrant Multiple-VM Creation and Configuration

Automatically provision multiple VMs with Vagrant and VirtualBox. Automatically install, configure, and test
Puppet Master and Puppet Agents on those VMs.

#### JSON Configuration File

The Vagrantfile retrieves multiple VM configurations from a separate `nodes.json` file in this line of `Vagrantfile` `nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']` . All VM configuration is
contained in the this JSON file. You can add additional VMs to the JSON file, following the existing pattern. The
Vagrantfile will loop through all nodes (VMs) in the `nodes.json` file and create the VMs. You can easily swap
configuration files for alternate environments since the Vagrantfile is designed to be generic and portable.

#### Instructions

```
vagrant up # brings up all VMs
vagrant ssh puppet-master.example.com

sudo service puppetmaster status # test that puppet master was installed
sudo service puppetmaster stop
sudo puppet master --verbose --no-daemonize
# Ctrl+C to kill puppet master
sudo service puppetmaster start
sudo puppet cert list --all # check for 'puppet' cert

# Shift+Ctrl+T # new tab on host
vagrant ssh node-01.example.com # ssh into agent node
sudo service puppet status # test that agent was installed
sudo puppet agent --test --waitforcert=60 # initiate certificate signing request (CSR)
```

Back on the Puppet Master server (puppet-master.example.com)

```
sudo puppet cert list # should see 'node-01.example.com' cert waiting for signature
sudo puppet cert sign --all # sign the agent node(s) cert(s)
udo puppet cert sign  node-01.example.com  # sign the agent node(s) cert(s)
sudo puppet cert list --all # check for signed/unsigned cert(s)
sudo puppet agent --fingerprint # Check for SHA fingerprint of client cet - Run this command on client
```

#### Forwarding Ports

Used by Vagrant and VirtualBox. To create additional forwarding ports, add them to the 'ports' array. For example:

```
"ports": [
       {
         ":host": 1080,
         ":guest": 8080,
         ":id": "port-1"
       },
       {
         ":host": 1090,
         ":guest": 8081,
         ":id": "port-2"
       }
     ]
```

#### Useful Multi-VM Commands

The use of the specific <machine> name is optional.

- `vagrant up <machine>`
- `vagrant reload <machine>`
- `vagrant destroy -f <machine> && vagrant up <machine>`
- `vagrant status <machine>`
- `vagrant ssh <machine>`
- `vagrant global-status`
