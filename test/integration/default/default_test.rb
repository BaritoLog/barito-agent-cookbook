# encoding: utf-8

# Inspec test for recipe barito-agent::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('fluentd') do
    it { should exist }
  end

  describe user('fluentd')  do
    it { should exist }
  end
end

describe package('build-essential zlib1g-dev') do
  it { should be_installed }
end

describe gem('fluent-plugin-barito') do
  it { should be_installed }
end

describe file('/opt/fluentd/conf/test-1.conf') do
  its('mode') { should cmp '0644' }
end

describe systemd_service('fluentd-test-1') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
