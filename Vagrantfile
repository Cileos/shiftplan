# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"
  config.vm.hostname = 'develop.clockwork.io'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3000, host: 13000
  config.vm.network "forwarded_port", guest: 5432, host: 15432

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  #config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.

  # We do not mount the default folder with vboxfs, because it is ultra-slow
  # and adds ~5s to every request (even to assets)

  # NFS is possible and extremly fast and needs no sync, but needs root
  # privileges on host and does not work with encrypted homes

  # The developer has to run `vagrant rsync-auto` in an extra terminal. Changes
  # take 2-5 seconds to be reflected in the vm.
  config.vm.synced_folder "./", "/home/vagrant/clockwork", type: 'rsync',
    rsync__auto:    true,
    rsync__exclude: ".git/",
    rsync__args: [
      "--verbose",
      "--archive",
      "--delete",
      "-z",
      "--links",
    ]


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Always update packet sources, the vagrant box may be really old
  config.vm.provision :shell, :inline => '/usr/bin/apt-get update -qq --yes --fix-broken'

  # setup working dir only to exploit in below
  working_dir = '/home/vagrant/puppet'
  config.vm.provision :shell, :inline => "mkdir -p #{working_dir}"
  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "vm/manifests"
    puppet.manifest_file  = "develop.pp"
    puppet.module_path = 'vm/modules'
    #puppet.options = "--verbose --debug"

    # before puppet is run, vagrand `cd`s into the working directory, failing to escape it.
    puppet.working_directory = "#{working_dir}; rvm use system || true"
  end

  config.vm.provision :shell, :path => "vm/bin/setup_system.sh"
  config.vm.provision :shell, :privileged => false, :path => "vm/bin/install-rvm.sh",  :args => "stable"
  config.vm.provision :shell, :privileged => false, :path => "vm/bin/install-ruby.sh", :args => "ruby-2.1.2 shiftplan"
  config.vm.provision :shell, :privileged => false, :path => "vm/bin/setup_app.sh"

  config.vm.post_up_message = <<-EOMESSAGE
to start the rails server you can use:

  vagrant ssh --command "cd clockwork && rails server"

Enjoy.
  EOMESSAGE
end
