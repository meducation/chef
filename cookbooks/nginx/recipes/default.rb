package "nginx"

service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template "/etc/nginx/nginx.conf" do
  notifies :reload, "service[nginx]"
end

directory "/etc/nginx/sites-available"
directory "/etc/nginx/sites-enabled"
directory "/srv/apps" do
  user 'ec2-user'
  group 'ec2-user'
end
