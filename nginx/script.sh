sleep 200
sudo cp /tmp/main.pp /etc/puppetlabs/code/environments/production/manifests/
sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/main.pp
