Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.hostname = "jhipster-devbox-nemesis"
    config.vm.provision :shell, :path => "scripts/setup.sh"
    config.vm.network :forwarded_port, host: 8080, guest: 8080
    config.vm.network :forwarded_port, host: 9000, guest: 9000
    config.ssh.insert_key = true
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.provider :virtualbox do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = true

        # Set the VirtualBox VM name equal to the hostname
        # vb.name = config.vm.hostname.to_s

        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--name", config.vm.hostname.to_s]
        vb.customize ["modifyvm", :id, "--memory", "8192"]
        vb.customize ["modifyvm", :id, "--vram", 128]
        vb.customize ["modifyvm", :id, "--cpus", 4]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
        vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
        vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
    end
end
