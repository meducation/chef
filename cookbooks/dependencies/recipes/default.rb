# Install via package manager
#============================
%w{ mysql-devel git patch gcc make zlib-devel curl-devel openssl openssl-devel gcc-c++ kernel-devel libxml2-devel ImageMagick ImageMagick-devel libxslt libxslt-devel memcached readline-devel}.each do |pkg|
  package pkg
end

# Install from source
#====================
#downloads_dir =  "/home/ec2-user/downloads/"
#directory downloads_dir do
#  user 'ec2-user'
#end
