Chef recipes for Meducation
===========================

Make web magic happen for Meducation.

This builds and installs a web-server. It requires a `cap deploy:cold` to install and start Meducation.

```
gem install chef --no-rdoc --no-ri
sudo mkdir /etc/chef
sudo cat 'cookbook_path "/chef_cookbooks"' > /etc/chef/solo.rb
sudo git clone git://github.com/iHiD/meducation-chef.git "/var/chef"

cd /var/chef && rvmsudo chef-solo -c solo.rb -j node.json 
```

## Pre-reqs

The instructions expect an EBS volume at /dev/sdm (~100GB)

## Still TODO

* Auto-update yum?
* Add remaining dependancies
* Install RVM through Chef (we have the Gem installed - just turn the scripts on)
* Make a couple of directories for ngnix config
* Automate SSL cert transfer.
* Automate 

At the moment running the follow does everything other than the SSL certs and starting Meducation. Do this BEFORE running Chef.

```sh
sudo yum update

sudo mke2fs -F -j /dev/sdm 
sudo mkdir /srv/apps
sudo mount -t ext3 /dev/sdm /srv/apps

export LANG=en_US.utf-8
\curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled
source /home/ec2-user/.rvm/scripts/rvm

echo 'export rvm_pretty_print_flag=1' >> ~/.rvmrc
# Now upload certs to /etc/nginx/certs/...
