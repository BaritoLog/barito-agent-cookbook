#
# Cookbook:: barito-agent
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'barito-agent'

default[cookbook_name]['config_dir'] = '/opt/fluentd/conf'
default[cookbook_name]['produce_url'] = 'https://barito-router.golabs.io/produce'
default[cookbook_name]['systemd_unit'] = {
  'Unit' => {
    'Description' => 'TO_BE_COMPLETED',
    'After' => 'network.target'
  },
  'Service' => {
    'Type' => 'simple',
    'User' => 'TO_BE_COMPLETED',
    'Group' => 'TO_BE_COMPLETED',
    'Restart' => 'on-failure',
    'ExecStart' => 'TO_BE_COMPLETED'
  },
  'Install' => {
    'WantedBy' => 'multi-user.target'
  }
}
default[cookbook_name]['loggings'] = []
