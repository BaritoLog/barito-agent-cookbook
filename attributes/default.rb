#
# Cookbook:: barito-agent
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'barito-agent'

default[cookbook_name]['sources'] = []
default[cookbook_name]['matches'] = []
default[cookbook_name]['groups'] = []
default[cookbook_name]['log_directory'] = "/var/log/td-agent"

## td-agent specific configuration
default[:td_agent][:version] = '3'
default[:td_agent][:plugins] = [
  'systemd',
  {"barito" => { "version" => "0.3.1"}}
]
default[:td_agent][:includes] = true
default[:td_agent][:default_config] = false
