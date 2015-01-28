# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64"

  config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
  config.vm.network :forwarded_port, guest: 443, host: 8443, auto_correct: true

  config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
#    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

#  config.vm.provision :shell, :path => "bootstrap.sh"

end
