# encoding: utf-8

# Inspec test for recipe barito-agent::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('td-agent') do
    it { should exist }
  end

  describe user('td-agent')  do
    it { should exist }
    its('groups') { should eq ['td-agent', 'root'] }
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

describe service('td-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
