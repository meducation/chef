# Install via package manager
#============================
%w{mysql mysql-devel git patch gcc make zlib-devel curl-devel openssl openssl-devel gcc-c++ kernel-devel libxml2-devel ImageMagick ImageMagick-devel libxslt libxslt-devel memcached readline-devel}.each do |pkg|
  package pkg
end

# Install from source
#====================
downloads_dir =  "/home/ec2-user/downloads/"
directory downloads_dir do
  user 'ec2-user'
end

{
  "sphinx" => "http://sphinxsearch.com/files/sphinx-2.0.7-release.tar.gz"
}.each do |program, url|
  filename = url.split("/").last
  directory = filename.gsub(".tar.gz", "")
  remote_file "#{downloads_dir}#{filename}.tar.gz" do
    source url
    notifies :run, "bash[install_#{program}]", :immediately
  end

  bash "install_#{program}" do
    user "root"
    cwd downloads_dir
    code <<-EOH
      tar -zxf #{filename}
      (cd #{directory}/ && ./configure && make && make install)
    EOH
    action :nothing
  end
end
