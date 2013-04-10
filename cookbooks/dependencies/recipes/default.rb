# Install via package manager
#============================
%w{mysql mysql-devel git patch gcc gcc-devel make zlib-devel curl-devel openssl openssl-devel gcc gcc-c++ kernel-devel libxml2-devel ImageMagick ImageMagick-devel libxslt libxslt-devel memcached readline-devel modssl}.each do |pkg|
  package pkg
end

# Install from source
#====================
{
  "sphinx" => "http://sphinxsearch.com/files/sphinx-2.0.7-release.tar.gz"
}.each do |program, url|
  filename = url.split("/").last
  directory = filename.gsub(".tar.gz", "")
  remote_file "/ec2-user/downloads/#{filename}.tar.gz" do
    source url
    notifies :run, "bash[install_#{program}]", :immediately
  end

  bash "install_#{program}" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      tar -zxf #{filename}
      (cd #{directory}/ && ./configure && make && make install)
    EOH
    action :nothing
  end
end
