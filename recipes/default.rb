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
  td_agent_source "source-#{source['name']}" do
    type source['type']
    tag source['name']
    parameters(
      path: source['path'],
      parse: {'@type' => 'none'}
    )
  end
end

node[cookbook_name]['matches'].each do |match|
  td_agent_match "match-#{match['name']}" do
    type match['type']
    tag match['name']
    parameters(
      application_secret: match['app_secret'],
      produce_url: node[cookbook_name]['produce_url'],
      buffer: {flush_mode: 'immediate'}
    )
  end
end
