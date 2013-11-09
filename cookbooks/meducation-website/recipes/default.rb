system

include_recipe "dependencies"
include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"

common = {name: "meducation-website", app_root: "/srv/apps/meducation-website"}

directory "/var/lib/nginx/" do
  recursive true
  mode 0775
end

directory "/var/lib/nginx/tmp/" do
  owner "ec2-user"
  group "nginx"
  recursive true
  mode 0775
end

directory common[:app_root] do
  recursive true
  owner "ec2-user"
end

directory "#{common[:app_root]}/releases" do
  owner "ec2-user"
  group "ec2-user"
end

directory "#{common[:app_root]}/shared" do
  owner "ec2-user"
  group "ec2-user"
end

{log: 'logs', files: 'files', cache: 'cache'}.each do |dir,mnt|
  link "#{common[:app_root]}/shared/#{dir}" do
    to "/mnt/#{mnt}"
    owner "ec2-user"
    group "ec2-user"
  end
end

%w(tmp sockets pids attachments ).each do |dir|
  directory "#{common[:app_root]}/shared/#{dir}" do
    owner "ec2-user"
    group "ec2-user"
    recursive true
    mode 0775
  end
end

template "#{node[:unicorn][:config_path]}/#{common[:name]}.conf.rb" do
  mode 0644
  source "unicorn.conf.erb"
  variables common
end

nginx_config_path = "/etc/nginx/sites-available/#{common[:name]}.conf"

template nginx_config_path do
  mode 0644
  source "nginx.conf.erb"
  variables common.merge(
    server_name: "www.meducation.net",
    redirect_server_names: "meducation.net"
  )
  notifies :reload, "service[nginx]"
end

nginx_site common[:name] do
  config_path nginx_config_path
  action :enable
end

bash "install_ruby_2" do
  user "ec2-user"
  cwd "/home/ec2-user"
  code <<-EOH
    rvm get stable
    rvm install 2.0.0
    rvm use 2.0.0 --default
  EOH
end
