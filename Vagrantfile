nodes = [
  { :hostname => 'c1',  :ip => '172.16.66.2', :ram => 1024 },
  #{ :hostname => 'w1',  :ip => '172.16.66.3', :ram => 1024 },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "centos/7";
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network "private_network", ip: node[:ip]
      memory = node[:ram] ? node[:ram] : 256;
      nodeconfig.vm.synced_folder "./", "/vagrant"
      nodeconfig.vm.provision "shell", path: "script.sh"

      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--memory", memory.to_s,
          "--cpus", "1"
        ]
      end
    end
  end
end
