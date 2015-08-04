require 'spec_helper'

describe 'rvm_fw::default' do
  describe command('which ruby') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the default RVM ruby" do
      expect(subject.stdout).to match(/\/usr\/local\/rvm\/rubies\/ruby-2.1.6\/bin\/ruby/)
    end
  end

  describe command('ruby --version') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/ruby 2.1.6/)
    end
  end
end
