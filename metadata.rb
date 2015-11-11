name 'rvm_fw'
maintainer 'Steven Haddox'
maintainer_email 'steven.haddox@gmail.com'
license 'MIT'
description 'Installs common ruby packages and RVM via RVM::FW'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/stevenhaddox/cookbook-rvm_fw'
issues_url 'https://github.com/stevenhaddox/cookbook-rvm_fw/issues'
version '0.2.3'

recipe 'rvm_fw::default', 'Install RVM via RVM::FW server'

depends 'build-essential', '~> 2'
depends 'apt', '~> 2.7'

supports 'centos'
supports 'fedora'
supports 'redhat'
supports 'debian'
supports 'ubuntu'
supports 'scientific'
