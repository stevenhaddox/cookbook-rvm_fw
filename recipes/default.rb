#
# Cookbook Name:: rvm_fw
# Recipe:: default
#
# Copyright (c) 2015 Steven Haddox

# Update apt packages for debian platforms
include_recipe 'apt' if node['platform_family'] == 'debian'
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

potentially_at_compile_time do
  # Pre-install packages to ensure RVM Rubies can compile against them
  # iconv libyaml libxml2 libxslt ncurses openssl readline zlib
  packages = value_for_platform_family(
    %w(rhel fedora suse) => %w(
      autoconf automake bash bison bzip2 curl gcc-c++ git grep gzip libffi-devel
      libtool libxml2-devel libxslt-devel libyaml-devel make openssl-devel patch
      readline readline-devel sed tar zlib zlib-devel
    ),
    %w(debian) => %w(
      autoconf automake bash bison build-essential bzip2 curl git-core grep gzip
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

  # Install default global Ruby
  execute 'install_default_ruby' do
    rvm_cmd = "source #{rvm_path}/scripts/rvm"
    ruby_version = "#{node['rvm_fw']['global_ruby']}"
    flags = '--default --verify-downloads 1'
    cmd = "#{rvm_cmd} && rvm install #{ruby_version} #{flags}"
    command "su #{rvm_user} -l -c '#{cmd}'"
    # Do not run if global ruby is already installed
    not_if do
      global_ruby_installed? rvm_path, rvm_user
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
  end
end
