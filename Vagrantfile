

nodes = [
  { :hostname => 'c1', :ram => 1024 },
  { :hostname => 'w1', :ram => 1024 }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "centos/7";
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      memory = node[:ram] ? node[:ram] : 256;
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
