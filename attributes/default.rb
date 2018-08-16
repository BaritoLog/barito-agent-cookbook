#
# Cookbook:: barito-agent
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'barito-agent'

default[cookbook_name]['sources'] = [
  {
    type: 'systemd',
    name: 'barito-journalctl',
    path: '/run/log/journal',
    raw_options: ['matches'],
    matches: [{'_SYSTEMD_UNIT': 'syslog.service'}],
    read_from_head: true,
    storage: {
      '@type': 'local',
      persistent: true,
      path: '/etc/td-agent/barito-journalctl.pos'
    },
    entry: {
      fields_strip_underscores: true,
      fields_lowercase: true
    }
  }
]

default[cookbook_name]['matches'] = [
  {
    type: 'barito_vm',
    name: 'barito-journalctl',
    application_secret: '123456-secret',
    produce_url: 'http://barito-producer',
    buffer: {
      flush_mode: 'immediate'
    }
  }
]

## td-agent specific configuration
default[:td_agent][:version] = '3'
default[:td_agent][:plugins] = [
  'systemd',
  {"barito" => { "version" => "0.1.8"}}
]
default[:td_agent][:includes] = true
default[:td_agent][:default_config] = false
