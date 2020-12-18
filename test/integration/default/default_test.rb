# encoding: utf-8

# Inspec test for recipe barito-agent::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('td-agent') do
    it { should exist }
  end

  case os.release
  when *["16.04", "18.04"]
    describe user('td-agent')  do
      it { should exist }
      its('groups') { should eq ['td-agent', 'root', 'systemd-journal'] }
    end
  else
    describe user('td-agent')  do
      it { should exist }
      its('groups') { should eq ['td-agent', 'root'] }
    end
  end
end

describe package('build-essential zlib1g-dev td-agent') do
  it { should be_installed }
end

describe file('/etc/td-agent/conf.d/source-barito-test.conf') do
  its('mode') { should cmp '0644' }
end

describe file('/etc/td-agent/conf.d/match-barito-test.conf') do
  its('mode') { should cmp '0644' }
end

describe file('/etc/td-agent/conf.d/filter-barito-test.conf') do
  its('mode') { should cmp '0644' }
end

describe service('td-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/logrotate.d/td-agent') do
  it { should be_a_file }
  its('mode') { should cmp '0644' }
  its('content') { should include '/var/log/td-agent/*.log' }
end
