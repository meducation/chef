%w{sphinx mysql mysql-devel git patch gcc gcc-devel make zlib-devel curl-devel openssl openssl-devel gcc gcc-c++ kernel-devel libxml2-devel ImageMagick ImageMagick-devel libxslt libxslt-devel memcached readline-devel modssl}.each do |dependency|
  package dependency
end

#service "sphinx" do
#  supports status: true, restart: true, reload: true
#  action [:enable, :start]
#end
