# Utviklemaskiner

# Kriterier
  - Vagrant
  - Ansible

## Installer [Vagrant](https://www.vagrantup.com/downloads.html)

Eksempel installering av versjon 2.1.2
```sh
sudo sh -c 'URL='https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb'; FILE=`mktemp`; wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE'
```

## Installer [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine)

Eksempel installering av siste version via ubuntu launchpad
```sh
su -c \
'echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list.d/ansible.list; \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367; \
apt update; \
apt -y install ansible'
```

### Benytte kvm som maskintilbyder

Du må installere en egen plugin, (vagrant-libvirt)[https://github.com/vagrant-libvirt/vagrant-libvirt]
for å bruke kvm med vagrant. Denne pluginen må kompileres, det betyr at du også må installere endel
utviklepakker i tjeneren.

1. `sudo apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev`
2. `vagrant plugin install vagrant-libvirt` 
3. Hvis du ønsker å bruke 2-veis katalogsynkronisering må NFS brukes. På tjeneren må du dermed installere nfs:
   `sudo apt-get install nfs-kernel-server nfs-common`
