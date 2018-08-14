#
# Cookbook:: barito-agent
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

node[cookbook_name]['loggings'].each do |logging|
  barito_agent_setup logging['name'] do
    config_dir      node[cookbook_name]['config_dir']
    log_file_path   logging['log_file_path']
    app_secret      logging['app_secret']
    produce_url     node[cookbook_name]['produce_url']
    process_user    logging['process_user']
    process_group   logging['process_group']
  end
end
