Vagrant.configure("2") do |config|
config.vm.box = "centos/7"
config.vm.provision "shell", path: "script.sh"
config.vm.network "public_network"
  

  config.vm.define "c1" do |m|
    m.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    
  end

  config.vm.define "w1" do |c1|
    c1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end

  end
end