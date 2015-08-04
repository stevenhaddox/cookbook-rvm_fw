name 'stow'
maintainer 'Steven Haddox'
maintainer_email 'steven.haddox@gmail.com'
license 'all_rights'
description 'Installs GNU Stow'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.2'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'fedora'
supports 'scientific'
supports 'redhat'

depends 'build-essential', '~> 2.2'
depends 'tar', '~> 0.6.0'
depends 'yum-epel', '~> 0.6.2'

recipe 'stow::default', 'Install GNU stow via package or source installation'
