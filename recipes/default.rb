#
# Cookbook:: barito-agent
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

apt_update
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

  td_agent_source "source-#{source['name']}" do
    type source['type']
    tag source['name']
    parameters source
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

execute 'Reload td-agent and systemctl' do
  command 'sudo systemctl daemon-reload && sudo systemctl restart td-agent'
end
