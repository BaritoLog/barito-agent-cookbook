property :logging_name,     String, name_property: true
property :group,            String, default: 'fluentd'
property :user,             String, default: 'fluentd'
property :config_dir,       String, required: true
property :log_file_path,    String, required: true
property :app_secret,       String, required: true
property :produce_url,      String, required: true
property :fluentd_version,  String, default: '1.2.4'
property :gem_path,         String, default: '/opt/chef/embedded/lib/ruby/gems/2.5.0/gems'
property :ruby_binary_path, String, default: '/opt/chef/embedded/bin'
property :process_group,    String
property :process_user,     String

default_action :install

action :install do
  action_create_user
  action_package_install
  action_configure
  action_systemd
end

action :create_user do
  group new_resource.group do
    system true
  end

  user new_resource.user do
    comment 'fluentd service account'
    group new_resource.group
    system true
    shell '/sbin/nologin'
  end
end

action :package_install do
  apt_update
  package %w(build-essential zlib1g-dev)
  gem_package 'fluentd' do
    version new_resource.fluentd_version
  end
  gem_package 'fluent-plugin-barito'
end

action :configure do
  directory new_resource.config_dir do
    user new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  template "#{new_resource.config_dir}/#{new_resource.logging_name}.conf" do
    cookbook 'barito-agent'
    source "fluentd.conf.erb"
    owner new_resource.user
    group new_resource.group
    mode '0644'
    variables(
              log_file_path: new_resource.log_file_path,
              app_secret: new_resource.app_secret,
              produce_url: new_resource.produce_url
    )
    notifies :restart, "barito_agent_setup[#{new_resource.logging_name}]", :delayed
  end
end

action :systemd do
  # Configure systemd unit with options
  unit = node[cookbook_name]['systemd_unit'].to_hash
  conf = "#{new_resource.config_dir}/#{new_resource.logging_name}.conf"
  bin = "#{new_resource.gem_path}/fluentd-#{new_resource.fluentd_version}/bin/fluentd"
  unit['Service']['User'] = new_resource.process_user || new_resource.user 
  unit['Service']['Group'] =  new_resource.process_group || new_resource.group
  unit['Service']['ExecStart'] = "/bin/bash -lc 'PATH=#{new_resource.ruby_binary_path}:$PATH #{bin} -c #{conf}'"

  systemd_unit "fluentd-#{new_resource.logging_name}.service" do
    enabled true
    active true
    masked false
    static false
    content unit
    triggers_reload true
    action %i[create enable start]
    notifies :restart, "barito_agent_setup[#{new_resource.logging_name}]", :delayed
  end
end

action :restart do
  service "fluentd-#{new_resource.logging_name}.service" do
    action [:enable, :restart]
    supports status: true, start: true, stop: true, restart: true
  end
end
