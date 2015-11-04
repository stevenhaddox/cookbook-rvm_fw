#!/usr/bin/env rake
require 'stove/rake_task'
Stove::RakeTask.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

desc 'Run rspec, foodcritic, and rubocop'
task default: [:foodcritic, :rubocop]

desc 'Runs foodcritic linter'
task :foodcritic do
  Rake::Task[:prepare_sandbox].execute

  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -f any -X spec test #{sandbox_path}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

task :prepare_sandbox do
  files = %w( *.md *.rb attributes definitions files libraries providers
              recipes resources templates )
  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox_path
end

private

def sandbox_path
  File.join(File.dirname(__FILE__), %w(tmp cookbooks stow))
end
