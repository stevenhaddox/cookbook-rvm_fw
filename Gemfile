source 'https://rubygems.org'

# Fix for nokogiri to install properly for ChefDK setup, not needed for CI
unless ENV['CI'] == true
  ENV['PKG_CONFIG_PATH'] = '/opt/chefdk/embedded/lib/pkgconfig'
end

gem 'berkshelf', '~> 3.0'
gem 'chef', '~> 12.4'

group :test do
  gem 'chefspec-coveragereports'
  gem 'rake'
  gem 'foodcritic'
  gem 'kitchen-vagrant'
  gem 'rubocop'
  gem 'test-kitchen'
end

group :development do
  gem 'pry'
  gem 'pry-plus', git: 'git://github.com/avantcredit/pry-plus.git'
  gem 'rb-readline'
  gem 'stove'
end
