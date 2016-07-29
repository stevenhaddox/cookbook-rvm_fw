#download the tar file from the web server
remote_file "/home/#{rvm_user}/#{node['rvm_fw']['compiled_file']}.tar.gz" do
  source "#{node['rvm_fw']['pre_compiled_src_url']}/#{node['rvm_fw']['compiled_file']}.tar.gz"
  owner "#{rvm_user}"
  group "#{rvm_user}"
  mode '0775'
  notifies :run, 'execute[unpack_rvm_tar]', :immediately
  action :create
  not_if do ::File.exists?("#{rvm_path}") end
end

# unpack the tar  and ensure proper permissions
execute 'unpack_rvm_tar' do
  command <<-EOH
    cd /home/#{rvm_user}/
    tar zxf #{node['rvm_fw']['compiled_file']}.tar.gz
    if [#{rvm_path} = "/usr/local/rvm"]; then
      mv .rvm rvm
      chown #{rvm_user}:#{rvm_user} -R rvm
    else
      chown #{rvm_user}:#{rvm_user} -R .rvm
    fi
    rm #{node['rvm_fw']['compiled_file']}.tar.gz
  EOH
  not_if do ::File.exists?("#{rvm_path}") end
  action :nothing
endd


