property :name, String, name_property: true
property :type, String, required: true
property :parameters, Hash, default: {}
property :raw_options, Hash

default_action :config

action :config do
  td_agent_source "source-#{new_resource.name}" do
    type new_resource.type
    tag new_resource.name
    parameters new_resource.parameters
    _raw_options new_resource.raw_options if new_resource.raw_options
    action :create
  end
end
