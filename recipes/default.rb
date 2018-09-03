#
# Cookbook:: barito-agent
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

if Chef::VERSION.split('.')[0].to_i > 12
  apt_update
else
  apt_update 'apt update' do
    action :update
  end
end
package %w(build-essential zlib1g-dev)

include_recipe 'td-agent'


node[cookbook_name]['sources'].each do |source|
  if source['type'] == 'systemd'
    execute 'Change group ownership of journalctl directory' do
      command 'sudo chown -R :systemd-journal /run/log/journal'
    end

    execute 'Add td-agent to systemd-journal group' do
      command 'sudo usermod -a -G systemd-journal td-agent'
    end
  end

  parameters = source.select { |k, v| k != 'raw_options' }

  td_agent_source "source-#{source['name']}" do
    type source['type']
    tag source['name']
    parameters parameters
    _raw_options source['raw_options'] if source['raw_options']
    action :create
  end
end

node[cookbook_name]['matches'].each do |match|
  td_agent_match "match-#{match['name']}" do
    type match['type']
    tag match['name']
    parameters match
    action :create
  end
end

service 'td-agent' do
  action :restart
end
