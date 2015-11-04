require 'spec_helper'

# Verify RVM user install works
describe 'rvm_fw::default' do
  rvm_user = 'vagrant'
  describe command("su #{rvm_user} -l -c 'source /home/vagrant/.rvm/scripts/rvm && which ruby'") do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the default RVM ruby" do
      expect(subject.stdout).to match(/\/home\/vagrant\/.rvm\/rubies\/ruby-2.2.2\/bin\/ruby\n/)
    end
  end

  describe command("su #{rvm_user} -l -c 'source /home/vagrant/.rvm/scripts/rvm && rvm --version'") do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/rvm 1.18.14/)
    end
  end

  describe command("/home/vagrant/.rvm/wrappers/default/ruby --version") do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/ruby 2.2.2/)
    end
  end

  describe command("su #{rvm_user} -l -c '/home/vagrant/.rvm/wrappers/default/gem list bundler'") do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
  end
end

# Verify system-wide install works
#describe 'rvm_fw::default' do
#  describe command('bash -c "source /usr/local/rvm/scripts/rvm && which ruby"') do
#    it "executes without error" do
#      expect(subject.exit_status).to eq 0
#    end
#    it "is the default RVM ruby" do
#      expect(subject.stdout).to match(/\/usr\/local\/rvm\/rubies\/ruby-2.2.2\/bin\/ruby\n/)
#    end
#  end
#
#  describe command('bash -c "source /usr/local/rvm/scripts/rvm && rvm --version"') do
#    it "executes without error" do
#      expect(subject.exit_status).to eq 0
#    end
#    it "is the right version" do
#      expect(subject.stdout).to match(/rvm 1.18.14/)
#    end
#  end
#
#  describe command('/usr/local/rvm/wrappers/default/ruby --version') do
#    it "executes without error" do
#      expect(subject.exit_status).to eq 0
#    end
#    it "is the right version" do
#      expect(subject.stdout).to match(/ruby 2.2.2/)
#    end
#  end
#
#  describe command('/usr/local/rvm/wrappers/default/gem list bundler') do
#    it "executes without error" do
#      expect(subject.exit_status).to eq 0
#    end
#  end
#end
