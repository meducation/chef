include_recipe "nginx"
include_recipe "unicorn"

gem_package "bundler"

common = {name: "meducation-website", app_root: "/srv/apps/meducation-website"}

directory common[:app_root] do
  recursive true
  owner "ec2-user"
end

directory "#{common[:app_root]}/releases" do
  owner "ec2-user"
  group "ec2-user"
end

%w(log tmp sockets pids).each do |dir|
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
  variables common.merge(server_name: "www.meducation.net")
  notifies :reload, "service[nginx]"
end

nginx_site common[:name] do
  config_path nginx_config_path
  action :enable
end
