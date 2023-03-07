Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/lunar64"
  config.vm.network "forwarded_port", guest:8080, host:8080
  config.vm.define "VaultwardenVM"
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    vb.name = "VaultwardenVM"
    # Customize the amount of memory on the VM:
    vb.memory = "4096" #2048"
    vb.cpus = 2
  end

  config.vm.provision "shell", path: "provision.sh", privileged: true
end
