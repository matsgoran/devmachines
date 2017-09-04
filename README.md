# Utviklemaskiner

## Installer [Vagrant](https://www.vagrantup.com/downloads.html)

Eksempel installering av versjon 1.9.8
```sh
sudo sh -c 'URL='https://releases.hashicorp.com/vagrant/1.9.8/vagrant_1.9.8_x86_64.deb?_ga=2.61996588.1857466031.1504505004-1261046924.1504505004'; FILE=`mktemp`; wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE'
```

### Benytte kvm som maskintilbyder

Du må installere en egen plugin, (vagrant-libvirt)[https://github.com/vagrant-libvirt/vagrant-libvirt]
for å bruke kvm med vagrant. Denne pluginen må kompileres, det betyr at du også må installere endel
utviklepakker i tjeneren.

1. `sudo apt-get install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev`
2. `vagrant plugin install vagrant-libvirt` 
