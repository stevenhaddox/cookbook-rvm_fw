require 'chef/mixin/shell_out'
module RvmfwCookbook
  # Prequisite methods for the Rvmfw cookbook
  module Prereqs
    # Vendor ptools gem into the cookbook repo and inject it into the $LOAD_PATH
    # gem install --install-dir files/default/vendor --no-document ptools
    $LOAD_PATH.unshift(*Dir[
      File.expand_path('../../files/default/vendor/gems/**/lib', __FILE__)
    ])
    require 'ptools'
    include Chef::Mixin::ShellOut

    # Warn if pre-installing packages isn't supporting
    def manual_libraries_warning
      ::Chef::Log.warn('RVM will continue installing without pre-installing the
                       following libraries:')
      %w( iconv libxml2 libxslt libyaml ncurses openssl readline zlib )
        .each do |lib|
        ::Chef::Log.warn(lib)
      end
      ::Chef::Log.warn 'It is strongly recommended to install these (or their
equivalent for your platform) before installing Ruby!'
    end

    # Create installation command for RVM via RVM::FW
    def build_rvm_install
      fail 'RVM::FW URL is a required attribute!' if node['rvm_fw']['url'].nil?
      if node['rvm_fw']['sudo'] == true
        bash_cmd = 'sudo bash'
      else
        bash_cmd = 'bash'
      end

      "\\#{dynamic_get_command} | #{bash_cmd}"
    end

    # Determine if wget is installed, fall back to curl
    def dynamic_get_command
      if ::File.which('curl')
        # curl version of RVM::FW install command
        "curl #{node['rvm_fw']['url']}/install"
      else
        # wget version of RVM::FW install command
        "wget -q -O #{node['rvm_fw']['url']}/install"
      end
    end

    # Detect if RVM is installed and the current version provided by RVM::FW
    def correct_rvm_installed?
      return false unless ::File.exist?("#{node['rvm_fw']['path']}/bin/rvm")
      ::Chef::Log.info '/usr/local/rvm/bin/rvm found'
      cmd = %{bash -c "source #{node['rvm_fw']['path']}/scripts/rvm && \
              rvm --version"}
      ::Chef::Log.debug("Running [#{cmd}]")
      results = shell_out(cmd)
      results.stdout.match(node['rvm_fw']['version'])
    end

    # Detect if global ruby version is already installed via RVM
    def global_ruby_installed?
      cmd = %{bash -c "source #{node['rvm_fw']['path']}/scripts/rvm && \
              rvm list"}
      ::Chef::Log.debug("Running [#{cmd}]")
      results = shell_out(cmd)
      results.stdout.match(node['rvm_fw']['global_ruby'])
    end

    # Detect if global ruby version is already set as default RVM ruby
    def rvm_default_set?
      cmd = %{bash -c "source #{node['rvm_fw']['path']}/scripts/rvm && \
              rvm list"}
      ::Chef::Log.debug("Running [#{cmd}]")
      results = shell_out(cmd)
      results.stdout.match("=\\* #{node['rvm_fw']['global_ruby']}")
    end
  end
end
