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
sudo yum install -y mysql mysql-devel git patch gcc gcc-devel make zlib-devel curl-devel openssl openssl-devel gcc gcc-c++ kernel-devel libxml2-devel ImageMagick ImageMagick-devel libxslt libxslt-devel memcached readline-devel modssl

export LANG=en_US.utf-8
\curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enabled
source /home/ec2-user/.rvm/scripts/rvm

echo 'export rvm_pretty_print_flag=1' >> ~/.rvmrc

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled
mkdir /srv/apps
sudo chown ec2-user:ec2-user /srv/apps

# Now upload certs to /etc/nginx/certs/...
