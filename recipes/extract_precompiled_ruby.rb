rvm_user = node['rvm_fw']['user']
if rvm_user == 'root'
  rvm_path = '/usr/local/rvm'
  rvm_parent_path =  '/usr/local/'
else
  rvm_path = "/home/#{rvm_user}/.rvm"
  rvm_parent_path =  "/home/#{rvm_user}/"
end

# Download the tar file from the web server
remote_file "#{rvm_parent_path}#{node['rvm_fw']['compiled_file']}.tar.gz" do
  source "#{node['rvm_fw']['pre_compiled_src_url']}/#{node['rvm_fw']['compiled_file']}.tar.gz"
  owner "#{rvm_user}"
  group "#{rvm_user}"
  mode '0775'
  action :create
  not_if do ::File.exists?("#{rvm_path}") end
end

# Unpack the tar and ensure proper permissions
execute 'unpack_rvm_tar' do
  command <<-EOH
  cd #{rvm_parent_path}
    tar zxf #{node['rvm_fw']['compiled_file']}.tar.gz
    rm #{node['rvm_fw']['compiled_file']}.tar.gz
    chown #{rvm_user}:#{rvm_user} -R .rvm
  EOH
  not_if do ::File.exists?("#{rvm_path}") end
end

# The root installs to a different folder , if root is the user  move the folder
execute 'remap_rvm_directory' do
  command <<-EOH
  cd #{rvm_parent_path}
    mv -f .rvm rvm
    chown #{rvm_user}:#{rvm_user} -R rvm
  EOH
  only_if do rvm_path == '/usr/local/rvm' end
end
