#
# Cookbook:: barito-agent
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

if node['platform_version'] == '20.04'
  execute 'Force fix tdagent repository configuration changes' do
    command 'sudo apt update -y'
  end
end

if Chef::VERSION.split('.')[0].to_i > 12
  apt_update
else
  apt_update 'apt update' do
    action :update
  end
end
package %w(build-essential zlib1g-dev)

include_recipe 'td-agent'

unless node['platform_version'] == '14.04'
  directory "/run/log/journal" do
    not_if { ::Dir.exist?("/run/log/journal") }
  end

  execute 'Change group ownership of journalctl directory' do
    command 'sudo chown -R :systemd-journal /run/log/journal'
  end

  execute 'Add td-agent to systemd-journal group' do
    command 'sudo usermod -a -G systemd-journal td-agent'
  end
end

node[cookbook_name]['groups'].each do |group|
  group "#{group}" do
    append true
    members 'td-agent'
    action :modify
    notifies :restart, "service[td-agent]", :delayed
  end
end

directory "/etc/td-agent/conf.d" do
  recursive true
  action :delete
end

directory "/etc/td-agent/conf.d" do
  owner 'td-agent'
  group 'td-agent'
  mode '0755'
  recursive true
  action :create
end

node[cookbook_name]['sources'].each do |source|
  barito_agent_source source['name'] do
    type source['type']
    parameters source
  end
end

node[cookbook_name]['matches'].each do |match|
  barito_agent_match match['name'] do
    type match['type']
    parameters match
  end
end

node[cookbook_name]['filters'].each do |filter|
  barito_agent_filter filter['name'] do
    type filter['type']
    parameters filter
  end
end
  
template '/etc/init.d/td-agent' do
  source 'systemd/td-agent-init.erb'
  owner 'root'
  group 'root'
  mode '0755'
  not_if { ::File.exist?("/etc/init.d/td-agent") }
end

case node["platform_version"]
when "14.04"
  service 'td-agent' do
    action :restart
    supports :status => true, :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Upstart
  end
else
  service 'td-agent' do
    action :restart
    supports :status => true, :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Systemd
  end
end

template '/etc/logrotate.d/td-agent' do
  source 'logrotate/td-agent.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables directory: "#{node['barito-agent']['log_directory']}"
end
