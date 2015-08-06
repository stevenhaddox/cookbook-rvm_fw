require 'spec_helper'

describe 'rvm_fw::default' do
  describe command('which ruby') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the default RVM ruby" do
      expect(subject.stdout).to match(/\/usr\/local\/rvm\/rubies\/ruby-2.2.2\/bin\/ruby\n/)
    end
  end

  describe command('rvm --version') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/rvm 1.18.14/)
    end
  end

  describe command('ruby --version') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/ruby 2.2.2/)
    end
  end

  describe command('gem list bundler') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
  end
end
