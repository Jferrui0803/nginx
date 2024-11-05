Vagrant.configure("2") do |config|
  config.vm.define "nginx_server" do |nginx|
    nginx.vm.box = "debian/bookworm64"
    nginx.vm.hostname = "nginx-server"
    nginx.vm.network "private_network", ip: "192.168.33.10"
    nginx.vm.provision "shell", path: "provision.sh"
  end
end