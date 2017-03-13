#
# Cookbook Name:: rvm_fw
# Recipe:: default
#
# Copyright (c) 2015 Steven Haddox

# Update apt packages for debian platforms
include_recipe 'apt' if node['platform_family'] == 'debian'
#TODO include_recipe 'yum-epel' if %w(rhel fedora).include?(node['platform_family'])
include_recipe 'build-essential'
require 'chef/mixin/shell_out'
Chef::Recipe.send(:include, ::Chef::Mixin::ShellOut)
Chef::Resource.send(:include, ::Chef::Mixin::ShellOut)
Chef::Recipe.send(:include, ::RvmfwCookbook::Prereqs)
Chef::Resource.send(:include, ::RvmfwCookbook::Prereqs)

rvm_user = node['rvm_fw']['user']
if rvm_user == 'root'
  rvm_path = '/usr/local/rvm'
else
  rvm_path = "/home/#{rvm_user}/.rvm"
end
# node['rvm_fw']['path'] overrides above default paths
rvm_path = node['rvm_fw']['path'] unless node['rvm_fw']['path'].nil?

# Pre-install packages to ensure RVM Rubies can compile against them
# iconv libyaml libxml2 libxslt ncurses openssl readline zlib
packages = value_for_platform_family(
  %w(rhel fedora suse) => %w(
    autoconf automake bash bison bzip2 curl gcc-c++ grep gzip libffi-devel
    libtool libxml2-devel libxslt-devel libyaml-devel make openssl-devel patch
    readline readline-devel sed tar zlib zlib-devel
  ),
  %w(debian) => %w(
    autoconf automake bash bison build-essential bzip2 curl grep gzip
    libreadline6 libreadline6-dev libssl-dev libxml2-dev libxslt-dev
    libyaml-dev openssl pkg-config sed tar zlib1g zlib1g-dev
  ),
  %w(gentoo) => [],
  %w(default) => []
)
if packages.empty?
  manual_libraries_warning
else
  packages.each do |pkg_name|
    package pkg_name
  end
end

package 'Install Git' do
  case node['platform_family']
  when 'rhel', 'fedora'
    package_name 'git'
  when 'debian', 'suse'
    package_name 'git-core'
  else
    package_name 'git-core'
  end
  not_if do
    # Detect if git is installed, if true skip installing it
    begin
      Mixlib::ShellOut.new('which git').run_command.error!
      true # Return true if there was no error, git is installed
    rescue
      false # Return false if git is not installed
    end
  end
  #not_if { system('which git') == true }
end

# Disable requiretty in /etc/sudoers file if enabled
ruby_block 'disable_requiretty' do
  block do
    file = Chef::Util::FileEdit.new('/etc/sudoers')
    file.search_file_replace_line(
      /^Defaults\s*requiretty.*$/,
      'Defaults !requiretty # Chef inserted via rvm_fw cookbook'
    )
    file.write_file
  end
  not_if do
    file = ::File.new('/etc/sudoers')
    contents = file.read
    contents.match(/^Defaults\s+!requiretty.*$/)
  end
end

# Install RVM from RVM::FW by dynamically building out the install command
execute 'install_rvm' do
  command "su #{rvm_user} -l -c '#{build_rvm_install}'"
  # Do not run if RVM is already installed AND matches expected version
  not_if do
    correct_rvm_installed? rvm_path, rvm_user
  end
end

# Create array of all rubies to install
ruby_versions = [node['rvm_fw']['global_ruby']]
extra_rubies = node['rvm_fw']['extra_rubies'] || []
unless extra_rubies.empty?
  extra_rubies = extra_rubies.to_ary if extra_rubies.class == String
  ruby_versions = ruby_versions.concat(extra_rubies)
end

ruby_versions.each do |ruby_version|
  # Install the specified ruby version
  execute "install_ruby #{ruby_version}" do
    rvm_cmd = "source #{rvm_path}/scripts/rvm"
    flags = '--verify-downloads 1'
    cmd = "#{rvm_cmd} && rvm install #{ruby_version} #{flags}"
    command "su #{rvm_user} -l -c '#{cmd}'"
    # Do not run if ruby version is already installed
    not_if do
      ruby_installed? rvm_path, rvm_user, ruby_version
    end
  end
end

# Set global ruby to --default
execute 'set_rvm_default' do
  ruby_install = node['rvm_fw']['global_ruby']
  cmd = "source #{rvm_path}/scripts/rvm && rvm use #{ruby_install} --default"

  command "su #{rvm_user} -l -c '#{cmd}'"
  ::Chef::Log.debug("Running [#{command}]")
  # Do not run if global ruby is set as default ruby
  not_if do
    rvm_default_set? rvm_path, rvm_user
  end
end

# Install bundler gem
execute 'install_bundler' do
  gem_bin = "#{rvm_path}/wrappers/default/gem"
  command "su #{rvm_user} -l -c '#{gem_bin} install bundler'"
  is_installed = <<-EOH
    #{gem_bin} list bundler -i
  EOH

  not_if is_installed, user: rvm_user
end
