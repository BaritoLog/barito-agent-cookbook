#
# Cookbook:: barito-agent
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'barito-agent'

default[cookbook_name]['produce_url'] = 'https://barito-router.golabs.io/produce'
default[cookbook_name]['sources'] = []
default[cookbook_name]['matches'] = []

## td-agent specific configuration
default[:td_agent][:version] = '3'
default[:td_agent][:plugins] = [
  {"barito" => { "version" => "0.1.8"}}
]
default[:td_agent][:includes] = true
default[:td_agent][:default_config] = false
